require "spec_helper"


describe Conditionator do

		class TestObj
			include Conditionator

			precondition_for :method, :precondition
			precondition_for :method_success, :precondition_true
			precondition_for :method_fail, [:precondition_false, :precondition_true]
			precondition_for :method_multiple, [:precondition, :precondition_true]

			#multi-precondition
			precondition_for [:m1,:m2], [:mpc1, :mpc2]

			#multi-postconditions
			postcondition_for [:m1,:m2], [:mpoc1, :mpoc2]

			postcondition_for :method_with_postcondition, [:postcondition1, :postcondition2]
			attr_accessor :chain_of_excecution

			def m1; end
			def m2; end

			#multi precondition
			def mpc1
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :mpc1
				true
			end
			def mpc2
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :mpc2
				true
			end
			
			def mpoc1
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :mpoc1
				true
			end
			def mpoc2
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :mpoc2
				true
			end

			def method_with_postcondition
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :method_with_postcondition
			end

			def method_multiple
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :method_multiple
			end

			def method
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :method
			end

			def method_success
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :method_success
			end

			def method_fail
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :method_fail
			end
			def precondition
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :precondition
			end

			def precondition_true
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :precondition_true
				true
			end

			def precondition_false
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :precondition_false
				false
			end

			def postcondition1
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :postcondition1
			end

			def postcondition2
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :postcondition2
			end

		end
	before :each do
		@test_obj = TestObj.new
	end

	describe "#precondition_for" do
		it "should take a target method, and the pre condition methods as arguments" do
			@test_obj.preconditions.key?(:method).should be_true
			@test_obj.preconditions[:method].include?(:precondition).should be_true
		end

		it "should take more than one precondition for a specific method" do
			@test_obj.preconditions[:method_multiple].should eq([:precondition, :precondition_true])
		end

		it "should execute the precondition methods before the actual method" do
			@test_obj.method
			@test_obj.chain_of_excecution.should =~ [:precondition, :method]
		end

		it "should pass the parameters of the method into the precondition method" do
			pending("Implementation")
		end

		it "should excecute the method only if the precondition is true" do
			@test_obj.method_success
			@test_obj.chain_of_excecution.should =~ [:precondition_true, :method_success]
		end

		it "should raise an exception (Conditionator::PrecondintionsNotMet) if one or more of the precondition fails" do
			expect { @test_obj.method_fail }.to raise_error(ConditionatorHook::PreconditionsNotMet)
		end

		it "should allow an array of methods to be preconditioned by an array of preconditions" do
			(@test_obj.preconditions[:m1] + @test_obj.preconditions[:m2]).uniq.should =~ [:mpc1, :mpc2] 
		end
	end

	describe "#postcondition_for" do

		it "should take a target method and the post condition methods as arguments" do
			@test_obj.postconditions.key?(:method_with_postcondition).should be_true
			@test_obj.postconditions[:method_with_postcondition].include?(:postcondition1).should be_true		end

		it "should take more than one postcondition for a specific method" do
			@test_obj.postconditions[:method_with_postcondition].should eq([:postcondition1, :postcondition2])
		end

		it "should excecute the postcondition methods after the actual method" do
			@test_obj.method_with_postcondition
			@test_obj.chain_of_excecution =~ [:method_with_postcondition, :postcondition1]
		end

		it "should allow an array of methods to be postconditioned by an array of postconditions" do
			(@test_obj.postconditions[:m1] + @test_obj.postconditions[:m2]).uniq.should =~ [:mpoc1, :mpoc2] 
		end

		it "should pass the parameters of the method into the postcondition method" do
			pending("Implementation")
		end

	end	
	
end