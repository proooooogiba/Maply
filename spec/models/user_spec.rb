require 'rails_helper'

RSpec.describe User, type: :model do
  let(:email_user) {"oleg-nsk@mail.ru"}
  let(:password_user) {"ts6GwTyLCzEYNmG"}
  let(:full_name) {"Ivan Pogiba"}
  describe 'Manipulating with model User' do
    it 'create User and check valid' do
      user = User.create(email: email_user, password: password_user, password_confirmation: password_user, full_name: full_name)
      expect(user).to be_valid
    end

    it 'create User and check invalid' do
      user = User.create(email: email_user, password: password_user, password_confirmation: password_user + '1', full_name: full_name)
      expect(user).to be_invalid
    end

    it 'create new User without params and try to save it' do
      expect(User.create.save).to be_falsey
    end

    it 'create new User and try to find it' do
      user = User.create(email: email_user, password: password_user, password_confirmation: password_user, full_name: full_name)
      expect(User.find_by(email: email_user)).to eq(user)
    end

    it 'create new User and try to find it by id' do
      user = User.create(email: email_user, password: password_user, password_confirmation: password_user, full_name: full_name)
      expect(User.find_by(id: user.id)).to eq(user)
    end

    it 'create new User and try to find it by full_name' do
      user = User.create(email: email_user, password: password_user, password_confirmation: password_user, full_name: full_name)
      expect(User.find_by(full_name: full_name)).to eq(user)
    end
  end

  describe 'Manipulating with followability' do
    let(:user1) {User.create(email: "oleg-nsk@mail.ru", password: "ts6GwTyLCzEYNmG", password_confirmation: "ts6GwTyLCzEYNmG", full_name: "Ivan Pogiba")}
    let(:user2) {User.create(email: "pogibuskaivan@gmail.com", password: "ts6GwTyLCzEYNmG", password_confirmation: "ts6GwTyLCzEYNmG", full_name: "Oleg")}
    it 'create new User and try to follow another User' do
      user1.send_follow_request_to(user2)
      expect(user1.following?(user2)).to be_falsey
    end

    it 'accept follow request from another User' do
      user1.send_follow_request_to(user2)
      user2.accept_follow_request_of(user1)
      expect(user1.following?(user2)).to be_truthy
    end

    it 'unfollow another User' do
      user1.send_follow_request_to(user2)
      user1.remove_follow_request_for(user2)
      expect(user1.following?(user2)).to be_falsey
    end

    it 'decline follow request from another User' do
      user1.send_follow_request_to(user2)
      user2.decline_follow_request_of(user1)
      expect(user1.following?(user2)).to be_falsey
    end

    it 'check mutual following' do
      user1.send_follow_request_to(user2)
      user2.send_follow_request_to(user1)
      user1.accept_follow_request_of(user2)
      user2.accept_follow_request_of(user1)
      expect(user1.mutual_following_with?(user2)).to be_truthy
    end
  end

  describe 'Manipulating with rooms' do
    let(:user1) {User.create(email: "oleg-nsk@mail.ru", password: "ts6GwTyLCzEYNmG", password_confirmation: "ts6GwTyLCzEYNmG", full_name: "Ivan Pogiba")}
    let(:user2) {User.create(email: "pogibuskaivan@gmail.com", password: "ts6GwTyLCzEYNmG", password_confirmation: "ts6GwTyLCzEYNmG", full_name: "Oleg Pogiba")}
    let(:room) {Room.create(name: "room1")}

    it 'create private room and check if users are participants' do
      private_room = Room.create_private_room([user1, user2], "room1")
      expect(private_room.participant?(private_room, user1)).to be_truthy
      expect(private_room.participant?(private_room, user2)).to be_truthy
    end

    it 'create private room and check if users are not participants' do
      user3 = User.create(email: "pogiba@yandex.ru", password: "123456", password_confirmation: "123456", full_name: "Indiana Johns")
      private_room = Room.create_private_room([user1, user2], "room1")
      expect(private_room.participant?(private_room, user3)).to be_falsey
    end
  end
end
