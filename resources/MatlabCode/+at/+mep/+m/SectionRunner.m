classdef SectionRunner < handle
% Runs section of given Script
% 
%% DESCRIPTION
% A simple class to run code by sections. Allows you to reuse Sections in scripts. Allows you to execute sections in any
% order multiple times.
%
%% TODO
%  [] - manipulate variables for any sections
%       possible solution is just to remove variables in sections and assign them 
%       just before the desired section needs to be evaluated e.g.:
%       nMess = 1:3;
%       nCh = 5;
%       sr.runSectionByTag("doSomeMagic")
%   
%
%% VERSIONING
%             Author: Andreas Justin
%           Copyright (C) Andreas Justin
%      Creation date: 2018-10-30
%             Matlab: 9.5, (R2018b)
%  Required Products: -
%
%% REVISONS
% V0.1 | 2018-10-30 | Andreas Justin      | first implementation
%
% See also 
%
%% EXAMPLES
%{
% >•< >•< >•< >•< >•< >•< >•< >•< >•< >•< >•< >•<
% create a new script, save is not needed
% insert the following lines:
%% hallo ($tag1)
a = 1;
b = 1;
c = 1
d = 1;

%% asdf ($tag2)
a = 2
b = 2;
c = 2;
%% asdfa
fprintf("asfddasdfasdfasd\n");
%% aaa

% >•< >•< >•< >•< >•< >•< >•< >•< >•< >•< >•< >•<
% execute this inside your script, NOTE: active editor
ae = at.mep.editor.EditorWrapper.getActiveEditor();
sr = at.mep.m.SectionRunner(ae);
sr.runSectionByTitle("%% asdfa")
sr.runSectionByTag("tag1")
sr.runSectionByTag("tag1")
sr.runSectionByTitle("%% asdfa")

%}
%% --------------------------------------------------------------------------------------------
properties (SetAccess = immutable)
    % matlab editor of script
    editor % com.mathworks.mde.editor.MatlabEditor
end
properties (Access = private)
    sectionTitle(:,1) string = ""
    sectionTitleLines(:,1) double = NaN
    code(:,1) string = ""
    
    addToCommandLine(1,1) logical = true
end

methods (Access = public)
    function obj = SectionRunner(editor)
        narginchk(1,1)
        if ~isa(editor, "com.mathworks.mde.editor.MatlabEditor")
            error("mep:InvalidArgument", "editor is not a matlab editor")
        end
        obj.editor = editor;
        obj.updateCode();
    end
    function updateCode(obj)
        % titles are returned as section-1-title, section-1-end, section-2-title...
        obj.sectionTitleLines = at.mep.editor.EditorWrapper.getSectionAllLines(obj.editor);
        obj.code = string(at.mep.editor.EditorWrapper.getTextArray(obj.editor));
        obj.sectionTitle = obj.code(obj.sectionTitleLines);
    end
    function enableCommandHistory(obj, value)
        obj.addToCommandLine = value;
    end
    
    function line = getLineSectionByTag(obj, tag)
        line = obj.sectionTitleLines(obj.sectionTitle.contains("($" + tag + ")"));
    end
    function runSectionByTag(obj, tag)
        obj.runSectionByLine(obj.getLineSectionByTag(tag));
    end
    function jumpToSectionyByTag(obj, tag)
        obj.jumpToSectionByLine(obj.getLineSectionByTag(tag));
    end
    
    function line = getLineSectionByTitle(obj, title)
        if ~title.endsWith(newline)
            title = title + newline();
        end
        line = obj.sectionTitleLines(obj.sectionTitle == title);
    end
    function runSectionByTitle(obj, title)
        obj.runSectionByLine(obj.getLineSectionByTitle(title));
    end
    function jumpToSectionByTitle(obj, title)
        obj.jumpToSectionByLine(obj.getLineSectionByTitle(title))
    end
    
    function runSectionByLine(obj, line)
        if numel(line) ~= 1
            error("mep:InvalidArgument", "line must be a scalar")
        end
        idx = find(obj.sectionTitleLines >= line, 1, "first");
        lineStart = obj.sectionTitleLines(idx);
        lineEnd = obj.sectionTitleLines(idx+1);
        cmd = strjoin(obj.code(lineStart:lineEnd),"");
        
        if obj.addToCommandLine
            com.mathworks.mlservices.MLCommandHistoryServices.add(cmd);
        end
        evalin("base", cmd);
    end
    function jumpToSectionByLine(obj, line)
        if numel(line) ~= 1
            error("mep:InvalidArgument", "line must be a scalar")
        end
        at.mep.editor.EditorWrapper.goToLine(obj.editor, line, false);
    end
end
end
