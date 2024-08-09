class Letter < ApplicationRecord
  # belongs_to :user
  belongs_to :profile

  FORMATS = ['short', 'standard (default)', 'long'].freeze

  validates :job_description, presence: true
  validates :format, presence: true, inclusion: { in: FORMATS }
  validates :company_name, presence: true


  def ai_letter_output
    prompt = "
      You are the most skilled hiring manager ever, and your goal is to craft the perfect cover letter for a
      candidate applying for a #{profile.desired_position} position #{company_name.present? ? "at #{company_name}" : ""}.

      The candidate has #{profile.years_of_experience} years of experience in #{profile.desired_position}.
      Their experience level is best described as #{seniority}. Your task is to present them as an ideal candidate,
      emphasizing their strengths and relevant skills.

      Please STRICTLY follow these specific instructions for the letter length:
      #{format == "short" ? "SHORT. Which means the letter should be concise, roughly half a page of A4." :
        format == "standard (default)" ? "STANDARD. Which means the letter should be detailed enough to fill an entire A4 page." :
        "LONG. The long format should be comprehensive and exceed one full A4 page. Don't make me repeat myself.
        Long means long. At least two pages of A4."}

      Here are some key details to consider while writing the letter:
      #{profile.details.present? ? "Candidate's background: #{profile.details}" : ""}
      #{profile.soft_skills.present? ? "Key soft skills: #{profile.soft_skills}" : ""}
      #{profile.technical_skills.present? ? "Technical skills: #{profile.technical_skills}" : ""}
      Highlight how these skills make them uniquely qualified for the role.

      The cover letter should make a compelling case for why this candidate is a top choice for the position.
      If they lack certain skills, explain how their flexibility and eagerness to learn make up for this.

      Focus on crafting a narrative that ties the candidate's experience and skills to the job description provided below.

      Please generate a letter that starts with an appropriate salutation ('Dear [Name]' if known, or 'Dear Sir or Madam').
      Do not include any headers (like name, email, address, etc.) and avoid any additional textmlike 'here is your text'
      or explanations.

      The letter should be #{format == "standard (default)" ? "a standard format, appropriate for filling an A4 page" :
      "#{format}"}.

      Job Description: #{job_description}

      You can include the following additional information about the candidate if relevant:
      #{profile.full_name.present? ? "Full name: #{profile.full_name}" : ""}"


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
