require 'spec_helper'

RSpec::Matchers.define :allow do |*args|
  match do |permission|
    permission.allow?(*args).should be_true
  end
end

describe Permission do
  describe "as guest" do
    subject { Permission.new(nil) }

    it { should allow(:about, :anything) }

    it { should allow('devise/sessions', :anything) }
    it { should allow('users/passwords', :anything) }
    it { should allow('users/registrations', :anything) }

    it { should_not allow('admin/users', :show) }
    it { should_not allow(:users, :show) }
  end

  describe "as user" do
    let(:user) { create(:instructor) }
    let(:instructable) { create(:instructable, user_id: user.id) }

    let(:other_user) { create(:instructor) }
    let(:other_instructable) { create(:instructable, user_id: other_user.id) }

    subject { Permission.new(user) }

    it {
      should allow(:about, :anything)
    }

    it {
      should allow('devise/sessions', :anything)
      should allow('users/passwords', :anything)
      should allow('users/registrations', :anything)
    }

    it {
      should allow(:users, :edit, user)
      should allow(:users, :show, user)
      should_not allow(:users, :edit, other_user)
      should_not allow(:users, :show, other_user)
    }

    it {
      should allow(:instructables, :new, instructable)
      should allow(:instructables, :edit, instructable)
      should_not allow(:instructables, :new, other_instructable)
      should_not allow(:instructables, :edit, other_instructable)
    }
  end

  describe "as coordinator" do
    let(:track) { Instructable::TRACKS.keys.first }
    let(:other_track) { Instructable::TRACKS.keys.last }

    let(:user) { create(:instructor, tracks: [track]) }
    let(:instructable) { build(:instructable, user_id: user.id) }

    let(:other_user) { create(:instructor) }
    let(:other_track_instructable) { build(:instructable, user_id: other_user.id, track: track) }
    let(:other_nontrack_instructable) { build(:instructable, user_id: other_user.id, track: other_track) }

    subject { Permission.new(user) }

    it {
      should allow(:instructables, :edit, instructable)
      should allow(:instructables, :edit, other_track_instructable)
      should_not allow(:instructables, :edit, other_nontrack_instructable)
    }
  end

  describe "as admin" do
    let(:user) { build(:user, admin: true) }
    let(:other_user) { create(:user) }
    subject { Permission.new(user) }

    it { should allow(:anything, :here) }
  end
end
