class Repository < ActiveRecord::Base
  belongs_to :profile

  def self.create_from_api(username, hash)
      profile = Profile.find_by(username: username)
      return if profile.nil?
      # r = Repository.where(github_id: hash["id"])
      repo = Repository.find_by(github_id: hash["id"])

      if repo
        if repo.need_to_update?
          repo.update_from_api(hash)
        else
          return
        end

      else

        Repository.create(body: hash,
                    github_id: hash["id"],
                    name: hash["name"],
                    repo_url: hash["url"],
                    number_of_forks: hash["forks_count"],
                    number_of_stars: hash["stargazers_count"],
                    last_modified_at: hash["updated_at"],
                    language: hash["language"],
                    profile_id: profile.id)
      end
  end

  def need_to_update?
    self.updated_at < 2.hours.ago
    true
  end

  def update_from_api(hash)
      self.update(body: hash,
                  github_id: hash["id"],
                  name: hash["name"],
                  repo_url: hash["url"],
                  number_of_forks: hash["forks_count"],
                  number_of_stars: hash["stargazers_count"],
                  last_modified_at: hash["updated_at"],
                  language: hash["language"]
                 )
  end

end
