class SupportController < ApplicationController

  def show
    flash[:errors] = nil
  end

  def report_a_problem
    clear_flash("report_a_problem")
  end

  def question_or_feedback
    clear_flash("question_or_feedback")
  end

  def process_problem

    logger.info "User submitted POST /report-a-problem form"

    flash[:errors] = {}

    unless params[:support_problem_message].present?
      flash[:errors][:support_problem_message] = "Enter a message"
    else
      flash[:support_problem_message] = params[:support_problem_message]
    end

    unless params[:support_problem_name].present?
      flash[:errors][:support_problem_name] = "Enter your name"
    else
      flash[:support_problem_name] = params[:support_problem_name]
    end

    unless params[:support_problem_email].present?
      flash[:errors][:support_problem_email] = "Enter your email address"
    else
      flash[:support_problem_email] = params[:support_problem_email]
    end

    if flash[:errors].empty?

      logger.debug "Validation succeeded for POST /report-a-problem form"

      logger.debug "Calling NotifyMailer.report_a_problem_email"

      NotifyMailer.report_a_problem(
          params[:support_problem_message],
          params[:support_problem_name],
          params[:support_problem_email]
      ).deliver_later

      logger.debug "Finished calling NotifyMailer.report_a_problem_email"

      clear_flash("problem")

      flash[:success] = true

    end

    logger.info "Finished processing of POST /report-a-problem form, re-rendering page"

    render :report_a_problem

  end

  def process_question

    logger.info "User submitted POST /question-or-feedback form"

    flash[:errors] = {}

    unless params[:support_question_or_feedback_message].present?
      flash[:errors][:support_question_or_feedback_message] = "Enter a message"
    else
      flash[:support_question_or_feedback_message] = params[:support_question_or_feedback_message]
    end

    flash[:support_question_or_feedback_name] = params[:support_question_or_feedback_name] if
        params[:support_question_or_feedback_name].present?
    flash[:support_question_or_feedback_email] = params[:support_question_or_feedback_email] if
        params[:support_question_or_feedback_email].present?

    if flash[:errors].empty?

      logger.debug "Validation succeeded for POST /question-or-feedback form"

      logger.debug "Calling SupportMailer.question_or_feedback_email"

      NotifyMailer.question_or_feedback(
          params[:support_question_or_feedback_message],
          params[:support_question_or_feedback_name],
          params[:support_question_or_feedback_email]
      ).deliver_later

      logger.debug "Finished calling SupportMailer.question_or_feedback_email"

      clear_flash("question_or_feedback")

      flash[:success] = true

    end

    logger.info "Finished processing of POST /question-or-feedback form, re-rendering page"

    render :question_or_feedback

  end

  def update

    unless params.key?("support_type")

      logger.info "Validation failed when posting support question form, " \
                    "no support_type parameter found"

      flash[:errors] = {
          support_type: "Not a valid choice"
      }

      render :show

    else

      if params[:support_type] == "report_a_problem"

        logger.info "Validation of POST /support form successful, redirecting user to /report-a-problem"

        redirect_to :report_a_problem

      elsif params[:support_type] == "ask_a_question"

        logger.info "Validation of POST /support form successful, redirecting user to /question-or-feedback"

        redirect_to :question_or_feedback

      else

        logger.info "Validation failed when posting support question form, " \
                      "invalid support_type parameter found"

        logger.debug "POST /support form contained a support_type parameter of '#{params[:support_type]}'"

        flash[:errors] = {
            support_type: "Not a valid choice"
        }

        render :show

      end

    end

  end

  private
  def clear_flash(page_type)
    flash[:errors] = nil
    flash[:success] = nil
    flash["support_#{page_type}_message"] = nil
    flash["support_#{page_type}_name"] = nil
    flash["support_#{page_type}_email"] = nil
  end

end
