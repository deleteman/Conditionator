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


			precondition_for :m3, :precondition_false
			precondition_for :m4, :precondition_false, {:failsafe => :mpoc1}
			postcondition_for :m3, :mpoc2

			
			#multi-postconditions
			postcondition_for [:m1,:m2], [:mpoc1, :mpoc2]


			postcondition_for :method_with_postcondition, [:postcondition1, :postcondition2]

			precondition_for :method_with_params, :can_values_be_divided?
			postcondition_for :method_with_params, :double_check_division

			precondition_for :method_fail2, :precondition_false, {:failsafe => :failsafe_method}
			precondition_for :method_fail3, :precondition_false, {:mute => true}

			attr_accessor :chain_of_excecution
			attr_accessor :division_was_correct

			def failsafe_method(*)
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :failsafe_method
			end

			def method_fail2
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :method_fail2
			end

			def method_fail3
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :method_fail3
			end

			def m1; end
			def m2; end
			def m3 
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :m3
			end
			def m4
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :m4
			end
			def m5
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :m5
			end

			def can_values_be_divided?(p1, p2) 
				if p1.is_a?(Integer) && p2.is_a?(Integer)
					if p2 > 0
						return true
					end
				end
				return false
			end

			def double_check_division p1, p2, result
				@division_was_correct = (p1/p2) == result
			end

			#it'll return the  of both parameters
			def method_with_params(p1, p2) 
				return (p1/p2)
			end

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

			def postcondition1 p
				@chain_of_excecution = [] if @chain_of_excecution.nil?
				@chain_of_excecution << :postcondition1
			end

			def postcondition2 p
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
			@test_obj.method_with_params(2,2).should eq(1)
			#pending("Implementation")
		end

		it "should excecute the method only if the precondition is true" do
			@test_obj.method_success
			@test_obj.chain_of_excecution.should =~ [:precondition_true, :method_success]
		end

		it "should raise an exception (Conditionator::PrecondintionsNotMet) if one or more of the precondition fails" do
			expect { @test_obj.method_fail }.to raise_error(ConditionatorHooks::PreconditionsNotMet)
		end

		it "should allow an array of methods to be preconditioned by an array of preconditions" do
			(@test_obj.preconditions[:m1] + @test_obj.preconditions[:m2]).uniq.should =~ [:mpc1, :mpc2] 
		end

		it "should accept an optional failsafe method" do
			@test_obj.failsafe_for(:method_fail2).should eq(:failsafe_method)
		end

		it "should excecute the failsafe method if one of the preconditions fails" do
			@test_obj.method_fail2
			@test_obj.chain_of_excecution.should =~ [:precondition_false, :failsafe_method]
		end

		it "should not throw an exeption if the developer want sends the :mute => true option" do
			@test_obj.method_fail3
			@test_obj.chain_of_excecution.should =~ [:precondition_false]
		end

		it "should not execute a postcondition if one of the preconditions fails" do
			expect { @test_obj.m3}.to raise_error(ConditionatorHooks::PreconditionsNotMet)
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

		it "should pass the parameters of the method, and its output into the postcondition method" do
			@test_obj.method_with_params(2,2)
			@test_obj.division_was_correct.should be(true)
		end

		it "should not execute a postcontidion if one of the preconditions fails and there is a failsafe in place" do
			@test_obj.m4
			@test_obj.chain_of_excecution =~ [:precondition_false]
		end

	
	end	
	
end