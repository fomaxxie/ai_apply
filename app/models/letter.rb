class Letter < ApplicationRecord
  belongs_to :profile

  FORMATS = ['short', 'standard (default)', 'long'].freeze

  validates :job_description, presence: true
  validates :format, presence: true, inclusion: { in: FORMATS }
  validates :company_name, presence: true


  def ai_letter_output
    prompt = "you are the best hiring manager that ever existed and you want to give the best
    possible advice on how to land a dream job as a #{profile.desired_position}
    #{company_name.present? ? "at #{company_name}" : ""}. You know I
    #{profile.years_of_experience < 3 ? "#{seniority}" : "with #{profile.years_of_experience} years of experience in this field"}
    in #{profile.desired_position} but by writing a perfect cover letter you will make me a top candidate.

    #{profile.details.present? ? "You should consider the following details: #{profile.details}" : ""}
    #{profile.soft_skills.present? ? "I have the following set of soft skills: #{profile.soft_skills}" : ""}
    #{profile.technical_skills.present? ? "and technical skills: #{profile.technical_skills}" : ""}
    Organically explain that even if I don't have all the required skills, I am very flexible to learn new ones.

    Now considering information about me and the job description below, help me write a perfect cover letter.

    Very importantly, just give a generated letter without any headers like name, email, address, date, etc, don't add any additional text like 'here is your text', etc.
    The output should be straightforward letter starting with either 'Dear' name of hiring manager if exists or just 'Dear Sir or Madam' if not.

    Here is a job description you should consider: #{job_description}
    The format of the letter should be #{format == "standard (default)" ? "standard, which means it should be long
    enough to fill A4 format" : "#{format}"}.

    You can consider adding the following information about me:
    #{profile.full_name.present? ? "full name: #{profile.full_name}" : ""}"


    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo", # Required.
          messages: [{ role: "user", content: prompt}], # Required.
          temperature: 0.7,
      })

    letter_output = response.dig("choices", 0, "message", "content")
    letter_output
  end

  private
  def seniority
    if profile.years_of_experience < 3
      "junior"
    elsif profile.years_of_experience < 6
      "middle"
    else
      "senior"
    end
  end
end
