require 'spec_helper'

describe Project do
  fixtures :all

  let(:new_valid_record) { Project.last }

  it 'has various states' do
    new_valid_record.state = :bogus_state
    new_valid_record.should_not be_valid
    new_valid_record.should have(1).error_on(:state)

    new_project = Project.new()
    new_project.draft?.should be true
    new_project.publish
    new_project.state.should == :published.to_s
    new_project.award
    new_project.state.should == :award_pending.to_s
    new_project.complete_award
    new_project.state.should == :awarded.to_s

    lambda { new_project.cancel }.should raise_error(AASM::InvalidTransition)
  end

  it_validates "presence of", :name
  it_validates "presence of", :project_type
  it_validates "presence of", :description
  it_validates "presence of", :bidding_end
  it_validates "presence of", :project_start
  it_validates "presence of", :project_end
  it_validates "presence of", :estimated_budget

  it 'allows empty fields when in draft' do
    new_valid_record.should be_valid
    new_valid_record.description = nil
    new_valid_record.bidding_end = nil
    new_valid_record.project_start = nil
    new_valid_record.estimated_budget = nil
    new_valid_record.should_not be_valid
    new_valid_record.state = :draft.to_s
    new_valid_record.should be_valid
  end

  it 'validates credit_value against estimated_budget' do
    old_budg = new_valid_record.estimated_budget
    new_valid_record.estimated_budget = nil
    new_valid_record.should have(2).errors_on(:estimated_budget)
    new_valid_record.should have(1).errors_on(:credit_value)
    new_valid_record.estimated_budget = old_budg
    new_valid_record.should be_valid

    old_credit_value = new_valid_record.credit_value
    new_valid_record.credit_value = 0
    new_valid_record.should_not be_valid
    new_valid_record.should have(1).errors_on(:credit_value)

    new_valid_record.credit_value = 6
    new_valid_record.should_not be_valid
    new_valid_record.should have(1).errors_on(:credit_value)
    new_valid_record.credit_value = old_credit_value
    new_valid_record.should be_valid

    new_valid_record.estimated_budget = 50000
    new_valid_record.credit_value = 1
    new_valid_record.should be_valid
    new_valid_record.estimated_budget = 50001
    new_valid_record.should_not be_valid
    new_valid_record.should have(1).errors_on(:credit_value)

    new_valid_record.estimated_budget = 500000
    new_valid_record.credit_value = 4
    new_valid_record.should be_valid
    new_valid_record.estimated_budget = 500001
    new_valid_record.should_not be_valid
    new_valid_record.should have(1).errors_on(:credit_value)
  end

  it 'enforces period business rules' do
    new_valid_record.bidding_end = Time.now + 1.week
    new_valid_record.bidding_period?.should be(true), "Bidding period before close."

    new_valid_record.bidding_end = Time.now - 1.second
    new_valid_record.award_period?.should be(true), "Award period afer close."
  end
end
