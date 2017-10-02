classdef (Abstract = false, Hidden, Sealed) ClassExample < handle & someOtherClass1 & someOtherClass2
   % Some describing comments

    properties (Access = public, Transient = true)
        % comment before var
        var1 % comment behind var
        % comment after var

        var2 = 12341
        var3@double = 43125
        var4 double
        var5 double = 5666666
        % var(1,1) double = 1
    end

    properties (Access = {?someOtherClass1})
        var6
    end


    %{
        COMMENT BLOCK
        at.mep.editor.tree.MFileTest.runTest
    %}

    %% CELL TITLE 1
    methods
    %% CELL TITLE 2

        function obj = ClassExample()
            % some construction code
            obj.var1 = 1;
        end

        function fNoATTR_InArg(obj)

        end

        function out1 = fNoATTR_InArgOutArg(obj)

        end

        function [out1, out2] = fNoATTR_InArgsOutArgs(~, inArg1, inArg2)

        end
    end

    %% CELL TITLE 3
    methods (Static, Hidden)
        function sfHidden()
        end
    end

    methods (Static = true, Hidden = false)
        function sf()
        end
    end
end

