class SupportController < ApplicationController

  def show
    flash[:errors] = nil
  end

  def process_problem

    logger.info "User submitted POST /report-a-problem form"

    flash[:errors] = {}

    unless params.key?("support_problem_message")
      flash[:errors][:support_problem_message] = "Enter a message"
    end

    unless params.key?("support_problem_name")
      flash[:errors][:support_problem_name] = "Enter your name"
    end

    unless params.key?("support_problem_email")
      flash[:errors][:support_problem_email] = "Enter your email address"
    end

    unless flash[:errors].empty?

      SupportMailer.report_a_problem_email(
          params[:support_problem_message],
          params[:support_problem_name],
          params[:support_problem_email]
      ).deliver_later

    end

    render :report_a_problem

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

        redirect_to :support_report_a_problem

      elsif params[:support_type] == "ask_a_question"

        logger.info "Validation of POST /support form successful, redirecting user to /question-or-feedback"

        redirect_to :support_question_or_feedback

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

end
