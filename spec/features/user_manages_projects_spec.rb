require "spec_helper"

feature "User manages projects" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "creates a project" do
    click_link "New Project"

    fill_in "Name", with: "My new project"
    click_button "Create Project"
    expect(page).to have_content("Project successfully created")
  end

  scenario "does not have access to other accounts projects" do
    create(:project)
    expect(Project.count).to eq(1)

    user = build(:user)
    subdomain2 = "#{subdomain}2"
    create(:account_with_schema, subdomain: subdomain2, owner: user)
    sign_in_user(user, subdomain: subdomain2)
    expect(Project.count).to eq(0)
  end

  scenario "displays a list of projects" do
    create(:project, name: "Hours")
    create(:project, name: "Capollo13")

    visit root_url(subdomain: subdomain)
    within ".projects" do
      expect(page).to have_content("Hours")
      expect(page).to have_content("Capollo13")
    end
  end
end