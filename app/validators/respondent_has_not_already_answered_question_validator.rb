class respondent_has_not_already_answered_question < ActiveModel::EachValidator

  def existing_responses(record)
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
        {:user_id => record.user_id, :answer_id => record.answer_id}]).first.response_count
  end



  def validate_each(record, attribute_name, value)
    existing_responses(record) == 0
  end
end