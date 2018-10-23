class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain: "test"
    status 404
    headers['Some-Header'] = 'Title'
  end

  def create; end

  def show
  end

end
