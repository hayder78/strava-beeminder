require 'spec_helper'

describe StravaIntegration do

  describe :activity_types do 
    it "should get activities matching type" do 
      types = StravaIntegration.activity_types
      expect(types.count).to be > 20 
    end
  end

  describe :get_activities do 
    it "should get today's activities" do 
      user = User.new(strava_token: ENV['STRAVA_ACCESS_TOKEN'] )
      integration = StravaIntegration.new(user: user)
      activities = integration.get_activities
      expect(activities.kind_of?(Array)).to be_truthy
    end
  end

  describe :activities_matching do 
    it "should get activities matching type" do 
      user = User.new(strava_token: ENV['STRAVA_ACCESS_TOKEN'] )
      start = Time.now - 1.years # So that we have enough activity ;)
      integration = StravaIntegration.new({user: user, start: start})
      activities = integration.activities_matching(' run')
      expect(activities.count).to be > 5
    end
  end

  describe :distance do 
    it "should convert distance" do 
      user = User.new(strava_token: ENV['STRAVA_ACCESS_TOKEN'] )
      integration = StravaIntegration.new({user: user, unit: 'feet'})
      expect(integration.distance(1)).to eq(3.2808333333)
    end
  end

  describe :activities_for_goal_integration do 
    it "should set the activity hash" do 
      user = create_user
      goal_integration = create_goal_integration(user)
      integration = StravaIntegration.new({goal_integration: goal_integration, start: (Time.now - 1.years)})
      formatted_activities = integration.activities_for_goal_integration
      expect(formatted_activities.keys.count).to be > 5
      formatted_activity = formatted_activities[formatted_activities.keys.first]
      expect(formatted_activity.keys).to eq([:distance, :time, :name])
    end
  end

end