#!/home/rof/.rvm/rubies/ruby-2.2.5/bin/ruby

require 'json'
require 'net/http'

class CodeshipRestartBuild
  def self.restart_build
    self.new.restart_build
  end

  def initialize
    @api_key = ENV['CODESHIP_API_KEY'] || abort("Please provide your API Key as an environment variable: CODESHIP_API_KEY=YOUR_CODESHIP_API_KEY")
    @project_id = ENV['CODESHIP_API_PROJECT_ID'] || abort("Please provide your project id as an environment variable: CODESHIP_API_PROJECT_ID=YOUR_CODESHIP_API_PROJECT_ID")
    @branch_name = ENV['CODESHIP_API_BRANCH'] || abort("Please provide your branch name as an environment variable: CODESHIP_API_BRANCH=YOUR_CODESHIP_API_BRANCH")
    @project = Project.new(@project_id, @branch_name, @api_key)
  end

  def restart_build
    puts "restarting Build ##{build_to_restart.id} from commit #{build_to_restart.commit_id[0..7]} on #{@project.repository_name}"
    build_to_restart.restart
  end

  def build_to_restart
    abort("We couldn't find any builds for project ##{@project_id}") if @project.builds.empty?
    Build.new(@project.builds.first, @api_key)
  end

  module HttpRequest
    def http_request
      http = Net::HTTP.new "codeship.com", 443
      http.use_ssl = true
      http
    end
  end

  class Project
    include HttpRequest

    def initialize(project_id, branch_name, api_key)
      @project_id = project_id
      @api_key = api_key
      @branch_name = branch_name
    end

    def builds
      @builds ||= project_json['builds']
    end

    def repository_name
      project_json['repository_name']
    end

    def project_json
      @project_json ||= JSON.parse(project_data.body)
    end

    def project_data
      project_data = http_request.get(url)
      abort(project_data.body) if [401, 404].include? project_data.code.to_i
      project_data
    end

    def url
      "/api/v1/projects/#{@project_id}.json?api_key=#{@api_key}&branch=#{@branch_name}"
    end
  end

  class Build
    include HttpRequest

    def initialize(build, api_key)
      @build = build
      @build_id = @build['id']
      @api_key = api_key
    end

    def id
      @build_id
    end

    def commit_id
      @build['commit_id']
    end

    def restart
      http_request.post(url, "api_key=#{@api_key}").body
    end

    def url
      "/api/v1/builds/#{@build_id}/restart.json"
    end
  end
end

if $0 == __FILE__
  CodeshipRestartBuild.restart_build
end
