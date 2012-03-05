# TODO project_documents and cover_photo, project_privileges, may_* functions, *_bid* functions, hold_bids_and_notify_bidders
require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  def setup
    @project = Project.last
    assert_valid(@project)
  end

  test "states" do
    @project.state = :bogus_state
    assert_invalid(@project)
    assert_field_invalid(@project, :state)

    new_project = Project.new()
    assert(new_project.draft?, "Initially draft")
    new_project.publish
    assert(new_project.published?, "Published")
    new_project.award
    assert(new_project.award_pending?, "Award Pending")
    new_project.complete_award
    assert(new_project.awarded?, "Awarded")

    e = assert_raise(AASM::InvalidTransition) { new_project.cancel }
    assert_match(/cannot transition from/i, e.message)
  end

  test "presence validations" do
    assert_presence_required(@project, :name)
    assert_presence_required(@project, :project_type)
    assert_presence_required(@project, :description)
    assert_presence_required(@project, :bidding_end)
    assert_presence_required(@project, :project_start)
    assert_presence_required(@project, :project_end)
    assert_presence_required(@project, :estimated_budget)

    @project.state = :draft.to_s
    @project.description = nil
    @project.bidding_end = nil
    @project.project_start = nil
    @project.estimated_budget = nil
    assert_valid(@project)
    assert_presence_required(@project, :name)
    assert_presence_required(@project, :project_type)
    @project.state = :published.to_s
    assert_invalid(@project)
  end

  test "line items" do
    @project.line_items = []
    assert_invalid(@project)
    assert_field_invalid(@project, :line_items)
  end

  test "credit value validated against estimated budget" do
    old_budg = @project.estimated_budget
    @project.estimated_budget = nil
    assert_field_invalid(@project, :estimated_budget)
    assert_field_invalid(@project, :credit_value)
    @project.estimated_budget = old_budg
    assert_valid(@project)

    old_credit_value = @project.credit_value
    @project.credit_value = 0
    assert_invalid(@project)
    assert_field_invalid(@project, :estimated_budget)
    assert_field_invalid(@project, :credit_value)
    @project.credit_value = 6
    assert_invalid(@project)
    assert_field_invalid(@project, :estimated_budget)
    assert_field_invalid(@project, :credit_value)
    @project.credit_value = old_credit_value
    assert_valid(@project)

    @project.estimated_budget = 50000
    @project.credit_value = 1
    assert_valid(@project)
    @project.estimated_budget = 50001
    assert_invalid(@project)
    assert_field_invalid(@project, :credit_value)

    @project.estimated_budget = 500000
    @project.credit_value = 4
    assert_valid(@project)
    @project.estimated_budget = 500001
    assert_invalid(@project)
    assert_field_invalid(@project, :credit_value)
  end

  test "period logic" do
    @project.bidding_end = Time.now + 1.week
    assert(@project.bidding_period?, "Bidding period before close")

    @project.bidding_end = Time.now - 1.second
    assert(@project.award_period?, "Bidding period before close")
  end
end
