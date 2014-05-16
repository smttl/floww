require_relative 'features_helper'

feature 'Answering question', %q(
  Signed in user can add an aswer to the question
  ) do

  given(:topic) { create(:topic_with_question) }

  def answer_question
    visit question_path(topic)
    fill_in 'Your answer', with: 'answer'
    click_on 'Post your answer'
  end

  context 'when signed in' do
    background { sign_in(create(:user)) }

    scenario 'user can add an answer with valid data', js: true do
      answer_question

      expect(current_path).to eq(question_path(topic))
      within '#answers' do
        expect(page).to have_content 'answer'
      end
    end

    scenario 'user can not add an answer with invalid data', js: true do
      visit question_path(topic)
      click_on 'Post your answer'

      expect(page).to have_content "can't be blank"
    end
  end

  context 'when not signed in' do
    scenario 'user should not see post answer button' do
      visit question_path(topic)

      expect(page).to_not have_button 'Post your answer'
    end

    scenario 'user should see sign in/up prompt' do
      visit question_path(topic)

      expect(page).to have_content(
        'You should sign in or sign up to answer this question')
    end
  end
end