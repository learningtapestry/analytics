test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

class ApiAppTest < WebAppTestBase
  def setup
    super
    LT::Seeds::seed!
    @scenario = LT::Scenarios::Students::create_joe_smith_scenario
    @joe_smith = @scenario[:student]
    @jane_doe = @scenario[:teacher]
    @section = @scenario[:section]
    @page_visits = @scenario[:page_visits]
    @site_visits = @scenario[:site_visits]
    @sites = @scenario[:sites]
    @pages = @scenario[:pages]
    @org = @scenario[:organizations][0]
  end

  def teardown
    super
  end

  def test_approved_site_list
    request '/api/v1/approved-sites'
    response_json = JSON.parse(last_response.body, symbolize_names: true)
    khan_found = false ; codeacad_found = false
    response_json.each do |approved_site|
      if approved_site[:url] == LT::Scenarios::Sites.khanacademy_data[:url] then khan_found = true end
      if approved_site[:url] == LT::Scenarios::Sites.codeacademy_data[:url] then codeacad_found = true end
    end

    assert_equal 200, last_response.status
    assert_equal true, khan_found
    assert_equal true, codeacad_found
  end

  def test_service_status
    request '/api/v1/service-status'
    response_json = JSON.parse(last_response.body, symbolize_names: true)

    assert_equal 200, last_response.status
    assert_equal true, response_json[:database]
    assert_equal true, response_json[:redis]
  end

  def test_obtain
    response_json = nil

    ### Test basic API call, don't expect to get back results, but check API shape
    params = { org_api_key: @org[:org_api_key],
               org_secret_key: @org[:org_secret_key],
               usernames: [ @joe_smith[:username] ],
               entity: 'site_visits' }
    post '/api/v1/obtain', params.to_json, 'content_type' => 'application/json' do
      body = last_response.body
      response_json = JSON.parse(body, symbolize_names: true) if body and body != 'null'
    end

    assert_equal 200, last_response.status
    assert response_json
    assert_equal response_json[:entity], 'site_visits'
    assert_equal (DateTime.now - 1.day).to_date, DateTime.parse(response_json[:date_range][:date_begin]).to_date
    assert_equal (DateTime.now).to_date, DateTime.parse(response_json[:date_range][:date_end]).to_date
    assert_equal response_json[:results], []

    params[:date_begin] = '2014-01-01'
    params[:date_end] = DateTime.now
    params[:entity] = 'page_visits'
    post '/api/v1/obtain', params.to_json, 'content_type' => 'application/json' do
      body = last_response.body
      response_json = JSON.parse(body, symbolize_names: true) if body and body != 'null'
    end

    ### Test a valid page_visit response (more tests avialable in LT::Utilities::APIDataFactory test suite)
    assert_equal 200, last_response.status
    assert response_json
    assert_equal response_json[:entity], 'page_visits'
    assert_equal @joe_smith[:username], response_json[:results][0][:username]
  end

  def test_obtain_fails

    ### No org_api_key or org_secret_key fail test

    response_json = nil

    params = { test: 'test' }
    post '/api/v1/obtain', params.to_json, 'content_type' => 'application/json' do
      response_json = JSON.parse(last_response.body, symbolize_names: true)
    end

    assert_equal 401, last_response.status
    assert_equal response_json[:status], 'Organization API key (org_api_key) and secret (org_secret_key) not provided'

    ### No usernames fail test

    params = { org_api_key: 'test', org_secret_key: 'test' }
    post '/api/v1/obtain', params.to_json, 'content_type' => 'application/json' do
      response_json = JSON.parse(last_response.body, symbolize_names: true)
    end

    assert_equal 400, last_response.status
    assert_equal response_json[:status], 'Username array (usernames) not provided'

    ### No entity fail test

    params[:usernames] = [ 'dummyuser' ]
    post '/api/v1/obtain', params.to_json, 'content_type' => 'application/json' do
      response_json = JSON.parse(last_response.body, symbolize_names: true)
    end

    assert_equal 400, last_response.status
    assert_equal response_json[:status], 'Entity type (entity) not provided'

    ### Bad entity fail test

    params[:org_api_key] = @org[:org_api_key]
    params[:org_secret_key] = @org[:org_secret_key]
    params[:entity] = 'junkentity'
    post '/api/v1/obtain', params.to_json, 'content_type' => 'application/json' do
      response_json = JSON.parse(last_response.body, symbolize_names: true)
    end

    assert_equal 400, last_response.status
    assert_equal response_json[:status], 'Unknown entity type: junkentity'

  end

end