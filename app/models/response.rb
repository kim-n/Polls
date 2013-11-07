class Response < ActiveRecord::Base
  attr_accessible :user_id, :answer_id

  validates :user_id, :presence => true
  validates :answer_id, :presence => true

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

end