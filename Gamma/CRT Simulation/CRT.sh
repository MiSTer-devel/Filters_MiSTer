#!/usr/bin/python

# Run this Python script to generate the gamma profile.

print("# CRT gamma by c0d3h4x0r\n")

gamma_map = {
    0.0: 1.9,
    0.1: 1.7,
    0.2: 1.5,
    0.3: 1.3,
    0.4: 1.1,
    0.5: 0.9,
    0.6: 0.8,
    0.7: 0.7,
    0.8: 0.6,
    0.9: 0.5
    }

for i in range(0, 256):
    percent_in = i / 255.0

    for k,v in gamma_map.items():
        if percent_in >= k:
            gamma = v
        else:
            break

    percent_out = percent_in ** gamma
    print("    " + str(int(255 * percent_out)))

