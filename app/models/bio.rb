class Bio < ApplicationRecord
  # belongs_to :user
  belongs_to :profile

  validates :cv_content, presence: true

  def ai_bio_output
    prompt = "As an expert hiring manager, provide a compelling bio for a candidate
    based on the CV and specific requirements listed below. This bio should succinctly
    summarize their experience and skills to make them an outstanding candidate for their
    desired position.
    CV Overview: #{cv_content}
    Additional Details: #{details}
    Target Position: #{profile.desired_position}
    Years of Experience: #{profile.years_of_experience} years.
    The bio should be concise, professional, and tailored to the target role."


    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo", # Required.
          messages: [{ role: "user", content: prompt}], # Required.
          temperature: 0.7,
      })

    bio_output = response.dig("choices", 0, "message", "content")
    return bio_output
  end

end
