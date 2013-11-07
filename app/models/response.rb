class Response < ActiveRecord::Base
  include ActiveModel::Validations

  attr_accessible :user_id, :answer_id

  validates :user_id, :presence => true
  validates :answer_id, :presence => true

  validate :respondent_has_not_already_answered_question
  validate :respondent_is_not_poll_author

  belongs_to(
    :answer_choice,
    :class_name => 'AnswerChoice',
    :foreign_key => :answer_id,
    :primary_key => :id
  )

  belongs_to(
    :respondent,
    :class_name => 'User',
    :foreign_key => :user_id,
    :primary_key => :id
  )

  def existing_responses
    Response.find_by_sql(["SELECT
        COUNT(*) AS response_count
      FROM
        responses r
      JOIN
        answer_choices a ON (r.answer_id = a.id)
      WHERE
        r.user_id = :user_id
        AND a.question_id =
        (SELECT a.question_id FROM answer_choices a WHERE (a.id = :answer_id))",
        {:user_id => self.user_id, :answer_id => self.answer_id}]).first.response_count
  end

  def respondent_is_poll_author?
    author = User.joins(authored_polls: [questions: :answer_choices]).where('answer_choices.id = ?', answer_id).first
    self.user_id == author.id
  end

  def respondent_has_not_already_answered_question
    existing_responses == "0" ? true : errors.add(:base, 'Respondent already answered question')
  end

  def respondent_is_not_poll_author
    respondent_is_poll_author? ? errors.add(:base, 'Respondent is Poll author') : true
  end


end