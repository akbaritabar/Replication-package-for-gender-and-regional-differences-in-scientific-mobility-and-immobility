## File name to use in search: figure_predicted_probability_gender.py ##

# ===========
## Author details ##
# ===========

# Script's author:      Aliakbar Akbaritabar
# Version:              2024-11-05
# Email:                akbaritabar@demogr.mpg.de
# GitHub:               https://github.com/akbaritabar
# Website:              https://www.demogr.mpg.de/en/about_us_6113/staff_directory_1899/aliakbar_akbaritabar_4098/

# Script for replication of analysis and figures from paper "A study of gender and regional differences in scientific mobility and immobility among researchers identified as potentially talented"

# Manuscript authors: Aliakbar Akbaritabar, Robin Haunschild and Lutz Bornmann


import pandas as pd
# to visualize
import plotnine as gg
# for log (10^3 etc) labels
from mizani.labels import label_number
#### Results log and progress report ####
from tolog import lg

# to see more pandas columns & not to use scientific notation
pd.set_option('max_colwidth',100)
pd.set_option('display.float_format', '{:.2f}'.format)

# from here: https://gist.github.com/thriveth/8560036
six_colors_colorblind = ['#377eb8', '#ff7f00', '#4daf4a', '#984ea3', '#e41a1c', '#dede00']

lg(f"These items are in the environment: {dir()}")

# ============================
#### For command line arguments ####
# ============================
import argparse
parser = argparse.ArgumentParser()

# System arguments
# use ", nargs='+'" if more than one input is given, below have to choose args.input[] and list element number to use
parser.add_argument("-i", "--input", help = "Input file to use", type = str, required = True, nargs='+')
parser.add_argument("-o", "--output", help = "Output data path", type = str, required = False, nargs='+')

args = parser.parse_args()

lg(f"Arguments received from command line: \n {args}")


# ============================
#### Read predicted probabilities ####
# ============================

talents1 = pd.read_csv(args.input[0])

lg(f"Data read from '{args.input[0]}'")
lg(f"A few rows: '{talents1.tail()}'")

# add percent for predicted probability
talents1['pred_percent'] = pd.Series(round(talents1['predicted'] * 100, ndigits=0)).astype(int)

talents1["x"] = pd.Categorical(talents1["x"], categories=talents1["x"].unique())
talents1["response.level"] = pd.Categorical(talents1["response.level"], categories=talents1["response.level"].unique())
talents1["group"] = pd.Categorical(talents1["group"], categories=talents1["group"].unique())


# ============================
#### Figure ####
# ============================

dodge_text = gg.position_dodge(width=0.90)

# how about having mobility in X axis?
fig2save = (
    gg.ggplot(talents1, gg.aes(x="response.level", y="pred_percent", group='x', fill='x'))
    + gg.geom_col(stat="identity", position="dodge")
    + gg.geom_text(
        gg.aes(label="pred_percent"),  # new
        position=dodge_text,
        angle=0,
        size=7,
        va="bottom"
    )
    + gg.scale_fill_manual(values=six_colors_colorblind, labels=['Others', 'Talents'])
    + gg.labs(x='', y="Predicted probability %", fill="")
    + gg.scale_y_continuous(breaks=[0, 10, 30, 50, 70], labels=[0, 10, 30, 50, 70], limits=[0, 70])
    + gg.facet_wrap('group')
    + gg.coord_flip()    
    + gg.theme_bw(base_family='Verdana')
    + gg.theme(legend_position=('bottom'), legend_direction='horizontal',
            axis_text_x=gg.element_text(size=9, angle=0),
             axis_text_y=gg.element_text(size=9),
             axis_title_x=gg.element_text(size=10),
             axis_title_y=gg.element_text(size=10),
             strip_text_x=gg.element_text(size=10, weight='bold'),
             figure_size=(5, 5)
            )
    + gg.guides(color=gg.guide_legend(ncol=2, nrow=1))
)

gg.ggplot.save(fig2save, 
    args.output[0], limitsize=False, dpi=500)


lg(f"Figure exported in: '{args.output[0]}'")
