#!/usr/bin/env python

import os
import sys
import getopt


def displayHelp():
    print("Script to change the theme of the Alacritty terminal, VSCodium/VSCode theme ")
    print("and `git diff` (delta) theme.")
    print("Tested with python 3.9.2")
    print("")
    print("python terminalTHemeSwitcher.py [OPTION]")
    print("")
    print("Options:")
    print(" -h, --help    show this help")
    print(" --dark        set all the themes to the dark mode")
    print(" --light       set all the themes to the light mode")


class themeSwitcherClass:
    class themeConfigParamClass:
        def __init__(self, file, startStr, endStr, themeLight, themeDark, sedCmdQuotes):
            self.file = file  # Configuration file which we change
            self.startStr = startStr  # String which specifies the start of an area which we are changing
            self.endStr = endStr  # String which specifies the end of an area which we are changing
            self.themeLight = themeLight  # String which is used as a light theme (in case of Alacritty it is a file)
            self.themeDark = themeDark  # String which is used as a dark theme (in case of Alacritty it is a file)
            self.sedCmdQuotes = sedCmdQuotes  # Which quotes to use with `sed` command

    def __init__(self):
        # Set default the theme
        self.theme = "light"

        # Git configuration
        gitConfigFile       = "~/.gitconfig"
        gitConfigStartStr   = "    #my-select-theme-start"
        gitConfigEndStr     = "    #my-select-theme-end"
        gitConfigThemeLight = "    features = my-feature-theme-light"
        gitConfigThemeDark  = "    features = my-feature-theme-dark"
        gitSedCmdQuotes     = "\""  # If there is single quote present in the sed pattern
                                         # then use an double quotes, and vice versa
        self.gitConfig = self.themeConfigParamClass(gitConfigFile,
                                                    gitConfigStartStr,
                                                    gitConfigEndStr,
                                                    gitConfigThemeLight,
                                                    gitConfigThemeDark,
                                                    gitSedCmdQuotes)

        # Alacritty configuraiton
        alacrittyConfigFile           = "~/.config/alacritty/alacritty.yml"
        alacrittyConfigStartStr       = "#my-color-theme-start"
        alacrittyConfigEndStr         = "#my-color-theme-end"
        alacrittyConfigThemeFileLight = "~/.config/alacritty/alacritty-theme/themes/gruvbox_light.yaml"
        alacrittyConfigThemeFileDark  = "~/.config/alacritty/alacritty-theme/themes/gruvbox_dark.yaml"
        alacrittySedCmdQuotes         = "\""  # If there is single quote present in the sed pattern
                                                   # then use an double quotes, and vice versa
        self.alacrittyConfig = self.themeConfigParamClass(alacrittyConfigFile,
                                                          alacrittyConfigStartStr,
                                                          alacrittyConfigEndStr,
                                                          alacrittyConfigThemeFileLight,
                                                          alacrittyConfigThemeFileDark,
                                                          alacrittySedCmdQuotes)

        vscConfigFile       = "~/.config/VSCodium/User/settings.json"
        vscConfigStartStr   = "    //my-select-theme-start"
        vscConfigEndStr     = "    //my-select-theme-end"
        vscConfigThemeLight = '    "workbench.colorTheme": "Solarized Light",'
        vscConfigThemeDark  = '    "workbench.colorTheme": "Monokai",'
        vscSedCmdQuotes     = "'"  # If there is single quote present in the sed pattern
                                        # then use an double quotes, and vice versa
        self.vscConfig = self.themeConfigParamClass(vscConfigFile,
                                                    vscConfigStartStr,
                                                    vscConfigEndStr,
                                                    vscConfigThemeLight,
                                                    vscConfigThemeDark,
                                                    vscSedCmdQuotes)

        nvimConfigFile       = "~/.config/nvim/plug-config/gruvbox.vim"
        nvimConfigStartStr   = '"my-select-theme-start'
        nvimConfigEndStr     = '"my-select-theme-end'
        nvimConfigThemeLight = "set bg=light"
        nvimConfigThemeDark  = "set bg=dark"
        nvimSedCmdQuotes     = "'"  # If there is single quote present in the sed pattern
                                         # then use an double quotes, and vice versa
        self.nvimConfig = self.themeConfigParamClass(nvimConfigFile,
                                                     nvimConfigStartStr,
                                                     nvimConfigEndStr,
                                                     nvimConfigThemeLight,
                                                     nvimConfigThemeDark,
                                                     nvimSedCmdQuotes)

# Replace all text between two lines
# `sed -e '/BEGIN/,/END/c\BEGIN\nfine, thanks\nEND' file`
#   - reference: https://stackoverflow.com/a/5179968
def replaceBetweenLines(themeConfigParam, theme):
    if os.path.exists(themeConfigParam.file) is True:
        file = themeConfigParam.file
        startStr = themeConfigParam.startStr
        endStr = themeConfigParam.endStr
        if theme == "light":
            newContext = themeConfigParam.themeLight
        elif theme == "dark":
            newContext = themeConfigParam.themeDark
        else:
            print("Wrong theme selected!")
            sys.exit(3)

        if themeConfigParam.sedCmdQuotes == '"':
            sedCmd = "sed -i \"/" + startStr + "/,/" + endStr + "/c\\" + startStr + "\\n" + newContext + "\\n" + endStr + "\" " + file
        elif themeConfigParam.sedCmdQuotes == "'":
            sedCmd = "sed -i '/" + startStr + "/,/" + endStr + "/c\\" + startStr + "\\n" + newContext + "\\n" + endStr + "' " + file
        else:
            print("Wrong quotes char specified: " + quotesChar)
            sys.exit(4)

        # print("sed command: " + sedCmd)
        os.system(sedCmd)
    else:
        print("File doesn't exists!")
        print("    File: " + file)
        sys.exit(2)

def setThemeAlacritty(themeConfigParam, theme):
    # Here we cheat a little bit because we don't just replace a string in the configuration
    # file but we need to copy a theme file into the configuration file

    if os.path.exists(themeConfigParam.file) and os.path.exists(themeConfigParam.themeLight) and \
            os.path.exists(themeConfigParam.themeDark):

        # Select a file which we need to copy into the configuration file
        if theme == "light":
            alacrittyThemeFile = themeConfigParam.themeLight
        else:
            alacrittyThemeFile = themeConfigParam.themeDark

        # Fix file context so it can be passed into the `sed` command
        with open(alacrittyThemeFile) as f:
            alacrittyThemeFileData = f.read()
            alacrittyThemeFileData = alacrittyThemeFileData.replace("\n", "\\n")
            alacrittyThemeFileData = alacrittyThemeFileData.replace("\r", "\\r")
            alacrittyThemeFileData = alacrittyThemeFileData.replace("\"", "\\\"")

        # Dirty hack in order to use the same `replaceBetweenLines()` function
        # We now use the same `.themeLight` or `.themeDark` variable which previously
        # held a file path.
        # We can do this because we won't need this variables any more
        if theme == "light":
            themeConfigParam.themeLight = alacrittyThemeFileData
        else:
            themeConfigParam.themeDark = alacrittyThemeFileData

        replaceBetweenLines(themeConfigParam, theme)

    else:
        print("Alacritty files don't exist!")
        print("    Alacritty configuration file: " + themeConfigParam.file)
        print("    Alacritty light theme file: " + themeConfigParam.themeLight)
        print("    Alacritty dark theme file: " + themeConfigParam.themeDark)
        sys.exit(2)

def setThemeVSC(themeConfigParam, theme):
    if os.path.exists(themeConfigParam.file) is True:
        themeConfigParam.startStr = themeConfigParam.startStr.replace("/", "\\/")
        themeConfigParam.endStr = themeConfigParam.endStr.replace("/", "\\/")
        replaceBetweenLines(themeConfigParam, theme)
    else:
        print("File doesn't exists!")
        print("    VSCode file: " + vscConfigFile)
        sys.exit(2)

def setThemes(themeSwitcher):
    replaceBetweenLines(themeSwitcher.gitConfig, themeSwitcher.theme)
    setThemeAlacritty(themeSwitcher.alacrittyConfig, themeSwitcher.theme)
    setThemeVSC(themeSwitcher.vscConfig, themeSwitcher.theme)
    replaceBetweenLines(themeSwitcher.nvimConfig, themeSwitcher.theme)

def replaceTildeWithFullPathInStr(strWithTilde):
    home = os.path.expanduser("~")
    return strWithTilde.replace("~", home)

def replaceTildeWithFullPathSingle(themeConfigParam):
    themeConfigParam.file = replaceTildeWithFullPathInStr(themeConfigParam.file)

    # This is needed in case the `.themeLight` or `.themeDark` is file path instead of just
    # a string (this is with the alacritty)
    themeConfigParam.themeLight = replaceTildeWithFullPathInStr(themeConfigParam.themeLight)
    themeConfigParam.themeDark = replaceTildeWithFullPathInStr(themeConfigParam.themeDark)

def replaceTildeWithFullPathAll(themeSwitcher):
    replaceTildeWithFullPathSingle(themeSwitcher.gitConfig)
    replaceTildeWithFullPathSingle(themeSwitcher.alacrittyConfig)
    replaceTildeWithFullPathSingle(themeSwitcher.vscConfig)
    replaceTildeWithFullPathSingle(themeSwitcher.nvimConfig)

# https://www.tutorialspoint.com/python/python_command_line_arguments.htm
def checkArgs(themeSwitcher, argv):
    try:
        opts, args = getopt.getopt(argv, "h", ["help", "light", "dark"])
    except getopt.GetoptError:
        displayHelp()
        sys.exit(1)

    for opt, arg in opts:
        if opt in ('-h', "--help"):
            displayHelp()
            sys.exit(0)
        elif opt in ("--light"):
            themeSwitcher.theme = "light"
        elif opt in ("--dark"):
            themeSwitcher.theme = "dark"

if __name__ == "__main__":

    themeSwitcher = themeSwitcherClass()
    checkArgs(themeSwitcher, sys.argv[1:])

    replaceTildeWithFullPathAll(themeSwitcher)

    if themeSwitcher.theme == "light" or themeSwitcher.theme == "dark":
        setThemes(themeSwitcher)
    else:
        print("Wrong theme selected!")
        sys.exit(3)

    sys.exit(0)

