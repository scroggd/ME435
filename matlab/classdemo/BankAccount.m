classdef BankAccount < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        balance
        rate
    end
    
    methods
        function obj = BankAccount(name, balance, rate)
            obj.name = name;
            obj.balance = balance;
            obj.rate = rate;
        end
    end
    
end

