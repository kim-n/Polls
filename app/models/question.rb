class Question < ActiveRecord::Base
  attr_accessible :poll_id, :question

  validates :poll_id, :presence => true
  validates :question, :presence => true

  belongs_to(
    :poll,
    :class_name => 'Poll',
    :foreign_key => :poll_id,
    :primary_key => :id
    )

  has_many(
    :answer_choices,
    :class_name => 'AnswerChoice',
    :foreign_key => :question_id,
    :primary_key => :id
  )

  def results
    answer_choices_with_counts = self.answer_choices.select("answer_choices.*, COUNT(responses.id) AS response_count").joins("LEFT OUTER JOIN responses ON responses.answer_id = answer_choices.id").group("answer_choices.id")

    answer_counts = {}
    answer_choices_with_counts.map! do |answer_choice|
      answer_counts[answer_choice.choice] = answer_choice.response_count
    end
    answer_counts
  end
end