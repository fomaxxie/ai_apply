class Bio < ApplicationRecord
  belongs_to :profile

  validates :cv_content, presence: true

  has_one_attached :cv_content

  def ai_bio_output
    prompt = "you are the best hiring manager that ever existed and you want to give the best"


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
