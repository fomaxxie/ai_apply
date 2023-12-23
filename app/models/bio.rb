class Bio < ApplicationRecord
  belongs_to :profile

  validates :cv_content, presence: true

  def ai_bio_output
    prompt = "you are the best hiring manager that ever existed and you want to give the best
    advice on how to write a bio which will summarize the candidate's experience and skills from
    their CV. You want to make sure that the candidate's bio is written in a way that will make
    them stand out from the crowd and get the job they want.
    Here is their CV: #{cv_content}. Make sure to also take into account the following details:
    #{details}. The candidate's bio should consider that they are applying for the position of
    #{profile.desired_position} and that they have #{profile.years_of_experience} years of experience."


    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo", # Required.
          messages: [{ role: "user", content: prompt}], # Required.
          temperature: 0.7,
      })

    bio_output = response.dig("choices", 0, "message", "content")
    bio_output
  end

end
