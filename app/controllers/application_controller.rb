class ApplicationController < ActionController::Base

  concerning :CommonExceptionHandling do
    class Forbidden < ActionController::ActionControllerError; end
    class Locked < ActionController::ActionControllerError; end
    class InvalidParameter < ActionController::ActionControllerError; end
    class ServiceUnavailable < ActionController::ActionControllerError; end

    included do
      rescue_from Exception,                      with: :render_500
      rescue_from InvalidParameter,               with: :render_400
      rescue_from ActiveRecord::RecordNotFound,   with: :render_404
      rescue_from ActionController::RoutingError, with: :render_404
      rescue_from ActionView::MissingTemplate,    with: :render_404
    end

    def render_500(e = nil)
      if e
        logger.error "Rendering 500 with exception: #{e.message}"
        logger.error "#{e.backtrace[0]}" if e.backtrace.present? and e.backtrace.length > 0
      end

      if request.xhr?
        render json: { error: '500 errors' }, status: 500
      else
        respond_to do |format|
          format.html {
            render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
          }
          format.json {
            @return_code = 500
            render 'api/errors/error', status: 500
          }
          format.all {
            render :text => 'Not Acceptable', status: 406
          }
        end
      end
    end

    def render_400(e = nil)
      if e
        logger.error "Rendering 400 with exception: #{e.message}"
        logger.error "#{e.backtrace[0]}" if e.backtrace.present? and e.backtrace.length > 0
      end

      if request.xhr?
        render json: { error: '400 errors' }, status: 400
      else
        respond_to do |format|
          format.html {
            render template: 'errors/error_400', status: 400, layout: 'application', content_type: 'text/html'
          }
          format.json {
            @return_code = 400
            render 'api/errors/error', status: 400
          }
          format.all {
            render :text => 'Not Acceptable', status: 406
          }
        end
      end
    end

    def render_404(e = nil)
      if e
        logger.error "Rendering 404 with exception: #{e.message}"
        logger.error "#{e.backtrace[0]}" if e.backtrace.present? and e.backtrace.length > 0
      end

      if request.xhr?
        render json: { error: '404 errors' }, status: 404
      else
        respond_to do |format|
          format.html {
            render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
          }
          format.json {
            @return_code = 404
            render 'api/errors/error', status: 404
          }
          format.all {
            render :text => 'Not Acceptable', status: 406
          }
        end
      end
    end
  end
end
