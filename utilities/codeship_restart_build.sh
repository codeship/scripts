#!/usr/bin/env ruby

# Maintains parity with behavior of original v1 API restart CodeShip build script -- https://github.com/codeship/scripts/blob/a2ba7093ce69c507ba5d997a38c506f4ed026087/utilities/codeship_restart_build.sh
# Now back in operation with v2 API -- https://apidocs.codeship.com/v2

# Since this script requires the generation of an access token with a CodeShip user/password
# we recommend that you create a CodeShip user for the sole purpose of providing access to restart builds.

# Your machine user can be relegated to a team with 'Contributor' role,
# but do be sure the team itself is authorized to access this particular CodeShip project.

# Here's our documentation for more information on managing teams -- https://documentation.codeship.com/general/account/organizations/#managing-teams-and-projects

require 'json'
require 'net/http'

class CodeshipRestartBuild

  def self.restart_build
    self.new.restart_build
  end

  def start_session
    uri = URI.parse("https://api.codeship.com/v2/auth")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@machine_user_email, @machine_user_password)
    request.content_type = "application/json"
    request["Accept"] = "application/json"

    req_options = {
      use_ssl: uri.scheme == "https"
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    raise "Issue encountered with attempt to obtain authorization token: #{response.body}" if response.code != "200"
    json_response = JSON.parse(response.body)

    organization = json_response["organizations"].find { |org| org["name"] == @org_name }
    raise "Organization not located. Here were the organizations found: #{json_response["organizations"]}" unless organization

    { token: json_response["access_token"], org_uuid: organization["uuid"] }
  end

  attr_reader :access_token, :org_uuid, :project_uuid, :branch_name

  def initialize
    @org_name = ENV['CODESHIP_ORG_NAME'] || abort("Please provide your CodeShip org name as an environment variable: CODESHIP_ORG_NAME=YOUR_CODESHIP_ORG_NAME")
    @project_uuid = ENV['CODESHIP_API_PROJECT_UUID'] || abort("Please provide your project uuid as an environment variable: CODESHIP_API_PROJECT_UUID=YOUR_CODESHIP_API_PROJECT_UUID")
    @branch_name = ENV['CODESHIP_API_BRANCH'] || abort("Please provide your branch name as an environment variable: CODESHIP_API_BRANCH=YOUR_CODESHIP_API_BRANCH")
    @machine_user_email = ENV['CODESHIP_MACHINE_USER_EMAIL'] || abort("Please generate a new CodeShip user with limited permissions and provide email as environment variable: CODESHIP_MACHINE_USER_EMAIL=YOUR_MACHINE_USER_EMAIL")
    @machine_user_password = ENV['CODESHIP_MACHINE_USER_PASSWORD'] || abort("Please generate a new CodeShip user with limited permissions and provide password as environment variable: CODESHIP_MACHINE_USER_PASSWORD=YOUR_MACHINE_USER_PASSWORD")
    @started_session = start_session
    @access_token = @started_session[:token]
    @org_uuid = @started_session[:org_uuid]
  end

  def restart_build
    build_uuid = get_most_recent_build_uuid

    uri = URI.parse("https://api.codeship.com/v2/organizations/#{org_uuid}/projects/#{project_uuid}/builds/#{build_uuid}/restart")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer #{access_token}"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    raise "There was an issue with attempting to restart the build: #{response.body}" unless response.code == "202"
  end

  def get_most_recent_build_uuid
    builds = http_get_builds
    build = builds.select {|build| build["branch"] == branch_name}.first
    build["uuid"]
  end

  def http_get_builds
    uri = URI.parse("https://api.codeship.com/v2/organizations/#{org_uuid}/projects/#{project_uuid}/builds")
    request = Net::HTTP::Get.new(uri)
    request.content_type = "application/json"
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer #{access_token}"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    raise "There was an issue with attempting to get the builds: #{response.body}" unless response.code == "200"
    json_response = JSON.parse(response.body)
    json_response["builds"]
  end
end

if $0 == __FILE__
  CodeshipRestartBuild.restart_build
end
