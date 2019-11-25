
### Introduction

**If you use MiSTer you should be using a custom filter for upscaling if you want high quality without uneven scaling and shimmering during scrolling.**

The MiSTer Filters and Gamma Github repository is here: ([MiSTer Filters and Gamma Github)[https://github.com/MiSTer-devel/Filters_MiSTer])

As of November 2018, MiSTer can use custom filter coefficients to define the interpolation used for scaling over the HDMI output (and VGA too with a mister.ini option). This allows MiSTer to scale images using well-known image scaling algorithms such as bicubic or lanczos scaling as well as other scaling methods better suited to scaling pixel graphics.  Special effects such as scanlines and lcd effects are also possible.

This github repository houses all of the Interpolation Filters that have been created so far for MiSTer: [MiSTer Filters/Gamma Github Repository](https://github.com/MiSTer-devel/Filters_MiSTer/tree/master/Releases)


As of November 2019 this github also contains Gamma Lookup Tables to allow MiSTer apply a gamma curves to cores with an updated framework.  James-F has created a number of curves that are included in the Gamma folder of this repository.

### How to use filter coefficients and gamma tables

To use any of the pre-made filter coefficients (or your own) you need:

* An updated version of MiSTer ([Main_MiSTer](https://github.com/MiSTer-devel/Main_MiSTer)). The first release with support was MiSTer_20181116.

* A supported core. Nearly all cores should have support now, but some Arcade Cores still have not been updated to the newer MiSTer framework as of November 2019.

* Filters. Filters are text files containing the coefficients for a specific interpolation method.  All filters must go in the Filters directory on your MiSTer SD card.  The most common way to obtain a set of filters is to run the MiSTer updater script (if your MiSTer has network access).  You can also download a release ZIP file from this repository or download a copy of this repository and copy the Filters folder over to your SD card by hand.

Filter Releases are here: [MiSTer Filters/Gamma Release Folder](https://github.com/MiSTer-devel/Filters_MiSTer/tree/master/Releases)

* Gamma. Gamma tables are text files containing the R,G,B entries of a gamma lookup table.  All gamma LUTs must go in the Gamma directory on your MiSTer SD card.  You can obtain gamma tables in the same way as the filters: either using the MiSTer updater script or by copying the Gamma folder from this repository over to your SD card by hand.

Once you have updated MiSTer and Cores and your filter/gamma coefficients in the right place you simply

* Start a supported core
* Go to page 2 of the core's OSD menu and under HDMI Scaler: change the option from "Filter - Internal" to "Filter - Custom"
* The option below "Filter - Custom" should now be enabled and will allow you to choose your filter from the files in your /Filters folder.
* Gamma Tables are implemented the same way and are just below the Filters options on page 2 of the OSD.  If you have Filters settings but not Gamma settings then you're using a core that does not yet support Gamma LUTs.

### Frequently Asked Questions 

Q: What filters should I use?

A: Use "Interpolation (Sharp)" and "SNES Interpolation (Sharp)" if you don't care for scanlines and just want good interpolation.  

But all of the filters Filters root are "Recommended Filters". So Interpolation (Sharp), Scanlines (Sharp), Scanlines (Soft), Vertical Scanlines (Sharp), Vertical Scanlines (Soft), LCD (Monochrome), and LCD (Color) are good defaults for most MiSTer cores.  

Q: Why would I want to use custom filter coefficients?

A: The default scaling algorithm of MiSTer is Nearest Neighbor/Lanczos and is not ideal for upscaling pixel graphics.  The filters allow much better looking scaling and special effects such as scanlines.

Q: Doesn't MiSTer already have scanlines through the "Scandoubler FX" option in the OSD?

A: Yes, but the scanlines available with "Scandoubler FX" are aligned to the scandoubled image and the scanlines through the filter coefficients are aligned to the original pixels in the scanline.  So you achieve better scanlines with filter coefficients in most cases.

Q: Where do I get sets of Filter Coefficients or Gamma LUTs?

A: Here. Or the update script which will get them from here. This is the official place to get these filters as of Dec 03, 2018

Q: Why are some filters labeled "SNES"?

A: MiSTer's SNES core outputs a 512 pixel wide image even when the SNES is in it's 256 pixel wide mode. This makes the horizontal interpolation too sharp.  The SNES specific filters take this into account.

Q: What do some filters have "NN" appended to the name?

A: Some people set MiSTer to scale to do integer scaling for the vertical upscaling (by setting vscale_mode=1 in mister.ini).  If you do this you can use the "NN" filters that only enable interpolation for horizontal scaling.

Q: Where is a filter that does XXXXX?

A: Check the subfolders for many filters.  Only a few are in the Filters root folder to make choosing a filter easier for newbies and non-technical people.  But there are many more to choose from.

### What do some filters look like?

The Filters folder contains a set of recommended filters for general use.  There are samples in the Samples folder of this repository. View these images at full size to make a proper evaluation.

**All screenshots below are from the Polyphase Previewer App that copies MiSTer's algorithm for scaling. You can try it out with emulator screenshots to see what ouput MiSTer will produce:** [Polyphase Previewer Github](https://github.com/rikard-softgear/PolyphasePreviewer) and [Polyphase Previewer Releases](https://github.com/rikard-softgear/PolyphasePreviewer/releases)

Interpolation (Sharp): 

![Interpolation (Sharp)](https://raw.githubusercontent.com/ghogan42/Filters_MiSTer/master/Samples/NEOGEO_Interpolation_Sharp.png)

Scanlines (Sharp):

![Scanlines (Sharp)](https://raw.githubusercontent.com/ghogan42/Filters_MiSTer/master/Samples/Neogeo_Scanlines_Sharp.png)

Scanlines (Soft):

![Scanlines (Soft)](https://raw.githubusercontent.com/ghogan42/Filters_MiSTer/master/Samples/NEOGEO_Scanlines_Soft.png)

LCD Effect (Monochrome):

![LCD Effect (Mono)](https://raw.githubusercontent.com/ghogan42/Filters_MiSTer/master/Samples/Gameboy_LCD_Monochrome.png)

LCD Effect (Color):

![LCD Effect (Color)](https://raw.githubusercontent.com/ghogan42/Filters_MiSTer/master/Samples/Gameboy_LCD_Color.png)

Vertical Scanlines (Soft):

![Vertical Scanlines (Soft)](https://raw.githubusercontent.com/ghogan42/Filters_MiSTer/master/Samples/DIGDUG_Scanlines_Vertical_Soft.png)


### Technial Information

The VIP scaler implements a generic 4 tap, 16 phase polyphase filter.  Details are on page 189 of the VIP scaler docs here: [Intel VIP Scaler Doc](https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/ug/ug_vip.pdf)

The Zipcores Application Notes pdf explains the workings of the filter much better than the ALtera/Intel docs: [Zipcores Application Notes](http://www.zipcores.com/datasheets/app_note_zc003.pdf)

Most of the currently available filter coefficients were generated with the Matlab code here: https://github.com/ghogan42/Filter-Coefficients-For-MiSTer

#### Tips for understanding the MiSTer filter coefficient text files:

* There are separate coefficients for horizontal and vertical scaling.
* Each row of the Filter Text File list the coefficients for taps T0, T1, T2, T3 for a paricular phase.
* The first row is phase 0 and corresponds to the center of tap T1.
* The ninth row is phase 8 and corresponds to the halfway point between T1 and T1 (so it's the pixel edge between T1 and T2).
* Then last row is phase 15 and corresponds to 15/16th of the way from T1 to T2 (so one phase before the center T2).

#### Sample Coefficient Set. Note the following:

* This is a 2 tap filter because we only have non-zero coefficients for taps T1 and T2
* The vertical coefficients don't sum to 128 for the middle phases. Since they sum to less than 128, the output will be darker. That's how scanlines are implemented.

<pre>
# range -128..128
# sum of line must not exceed the range!

# Sharp Bilinear on x-axis and y-axis
# 40% Scanlines on y-axis

# horizontal coefficients
   0, 128,   0,   0
   0, 128,   0,   0
   0, 127,   1,   0
   0, 125,   3,   0
   0, 120,   8,   0
   0, 112,  16,   0
   0, 101,  27,   0
   0,  85,  43,   0
   0,  64,  64,   0
   0,  43,  85,   0
   0,  27, 101,   0
   0,  16, 112,   0
   0,   8, 120,   0
   0,   3, 125,   0
   0,   1, 127,   0
   0,   0, 128,   0

# vertical coefficients
   0, 128,   0,   0
   0, 126,   1,   0
   0, 116,   5,   0
   0, 102,  10,   0
   0,  86,  16,   0
   0,  71,  21,   0
   0,  57,  26,   0
   0,  46,  31,   0
   0,  38,  38,   0
   0,  31,  46,   0
   0,  26,  57,   0
   0,  21,  71,   0
   0,  16,  86,   0
   0,  10, 102,   0
   0,   5, 116,   0
   0,   1, 126,   0
</pre>
