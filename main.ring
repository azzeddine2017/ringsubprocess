# Load required libraries
load "stdlib.ring"
load "consolecolors.ring"

# Global variables and constants
BANNER_DELAY = 0.3
LINE_DELAY = 0.1
SECTION_DELAY = 0.5
TOTAL_WIDTH = 76
PADDING = 4

# ASCII Art and content
title = [
    # RING ASCII Art (Green)
    [
        "██████╗ ██╗███╗   ██╗ ██████╗",
        "██╔══██╗██║████╗  ██║██╔════╝",
        "██████╔╝██║██╔██╗ ██║██║  ███╗",
        "██╔══██╗██║██║╚██╗██║██║   ██║",
        "██║  ██║██║██║ ╚████║╚██████╔╝",
        "╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝"
    ],
    # SUBPROCESS ASCII Art (Red)
    [
        "███████╗██╗   ██╗██████╗ ██████╗ ██████╗  ██████╗  ██████╗███████╗███████╗███████╗███████╗",
        "██╔════╝██║   ██║██╔══██╗██╔══██╗██╔══██╗██╔═══██╗██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝",
        "███████╗██║   ██║██████╔╝██████╔╝██████╔╝██║   ██║██║     █████╗  ███████╗███████╗███████╗",
        "╚════██║██║   ██║██╔══██╗██╔═══╝ ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║╚════██║╚════██║",
        "███████║╚██████╔╝██████╔╝██║     ██║  ██║╚██████╔╝╚██████╗███████╗███████║███████║███████║",
        "╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚═════╝╚══════╝╚══════╝╚══════╝╚══════╝"
    ],
    # EXTENSION ASCII Art (White)
    [
        "███████╗██╗  ██╗████████╗███████╗███╗   ██╗███████╗██╗ ██████╗ ███╗   ██╗",
        "██╔════╝╚██╗██╔╝╚══██╔══╝██╔════╝████╗  ██║██╔════╝██║██╔═══██╗████╗  ██║",
        "█████╗   ╚███╔╝    ██║   █████╗  ██╔██╗ ██║███████╗██║██║   ██║██╔██╗ ██║",
        "██╔══╝   ██╔██╗    ██║   ██╔══╝  ██║╚██╗██║╚════██║██║██║   ██║██║╚██╗██║",
        "███████╗██╔╝ ██╗   ██║   ███████╗██║ ╚████║███████║██║╚██████╔╝██║ ╚████║",
        "╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝"
    ],
    # Version and Info Box (Yellow)
    [
        "╭────────────────────────────── Version 1.0.0 ──────────────────────────────╮",
        "│                                                                           │",
        "│  Author: Azzeddine Remmal                                                 │",
        "│  GitHub: github.com/azzedinedev/RingSubprocess                            │",
        "│                                                                           │",
        "╰───────────────────────────────────────────────────────────────────────────╯"
    ]
]

# Package description
description = "A modern and powerful subprocess management extension for the Ring programming language, " +
              "providing an intuitive interface for creating and managing system processes with " +
              "advanced features and real-time capabilities."

# Key features with emoji icons
features = [
    ["🎯", "Simple & Modern API Design"],
    ["⚡", "High Performance Process Management"],
    ["🔄", "Real-time Output Streaming"],
    ["📊", "Advanced Process Analytics"],
    ["🛡️", "Robust Error Handling"],
    ["📡", "Asynchronous Operations"],
    ["🔌", "Flexible Input/Output Control"],
    ["📦", "Cross-platform Compatibility"],
    ["🔍", "Detailed Process Monitoring"],
    ["⚙️", "Customizable Process Settings"]
]

# Main Entry Point
func main
    displayBanner()

# Helper Functions
func printColored text, fgColor, bgColor
    cc_print(fgColor | bgColor, text)

func typeEffect text, delay
    for c in text
        see c
        sleep(delay)
    next
    see nl

func padString str, width
    if len(str) >= width 
        return left(str, width) 
    ok
    return str + copy(" ", width - len(str))

func calculateFeatureSpacing text
    return TOTAL_WIDTH - (len(text) + PADDING)

# Main Display Functions
func displayBanner
    # Display ASCII Art Title
    displayAsciiArt()
    
    # Display Description
    displayDescription()
    
    # Display Features
    displayFeatures()

func displayAsciiArt
    colors = [CC_FG_GREEN, CC_FG_RED, CC_FG_WHITE, CC_FG_YELLOW]
    
    for i = 1 to len(title)
        for j in title[i]
            see Tab + Tab + cc_print(colors[i] | CC_BG_NONE, j) + nl
            sleep(BANNER_DELAY)
        next
        see nl
        sleep(SECTION_DELAY)
    next

func displayDescription
    see nl + printColored("╭────────────────────────────── Description ──────────────────────────────╮", 
                         CC_FG_BLUE, CC_BG_NONE) + nl

    words = split(description, " ")
    line = ""
    
    for word in words
        if len(line + word) > TOTAL_WIDTH - PADDING
            printDescriptionLine(line)
            line = word + " "
        else
            line += word + " "
        ok
    next
    
    if len(line) > 0
        printDescriptionLine(line)
    ok
    
    see printColored("╰───────────────────────────────────────────────────────────────────────────╯", 
                     CC_FG_BLUE, CC_BG_NONE) + nl

func printDescriptionLine text
    see printColored("│ ", CC_FG_BLUE, CC_BG_NONE) + 
        printColored(padString(text, TOTAL_WIDTH), CC_FG_WHITE, CC_BG_NONE) + 
        printColored(" │", CC_FG_BLUE, CC_BG_NONE) + nl
    sleep(LINE_DELAY)

func displayFeatures
    see nl + printColored("╭────────────────────────────── Features ────────────────────────────────╮", 
                         CC_FG_BLUE, CC_BG_NONE) + nl
    
    for feature in features
        spacing = calculateFeatureSpacing(feature[1] + " " + feature[2])
        see printColored("│ ", CC_FG_BLUE, CC_BG_NONE) + 
            printColored(feature[1] + " ", CC_FG_YELLOW, CC_BG_NONE) + 
            printColored(feature[2] + copy(" ", spacing), CC_FG_WHITE, CC_BG_NONE) + 
            printColored("│", CC_FG_BLUE, CC_BG_NONE) + nl
        sleep(LINE_DELAY)
    next
    
    see printColored("╰───────────────────────────────────────────────────────────────────────────╯", 
                     CC_FG_BLUE, CC_BG_NONE) + nl


