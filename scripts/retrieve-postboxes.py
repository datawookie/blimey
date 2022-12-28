# Retrieve postbox locations from https://postboxes.dracos.co.uk/.

import time
import requests
import csv
import numpy as np
import pandas as pd

headers = {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0',
    'Accept': '*/*',
    'Accept-Language': 'en-US,en;q=0.5',
    'Connection': 'keep-alive',
    'Referer': 'https://postboxes.dracos.co.uk/',
    'Sec-Fetch-Dest': 'empty',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'same-origin',
    'Pragma': 'no-cache',
    'Cache-Control': 'no-cache',
}

LON_DELTA=0.5
LAT_DELTA=0.5

LON_MIN=-8
LON_MAX=2
LAT_MIN=49
LAT_MAX=59

postboxes = []

for lat in np.arange(LAT_MIN, LAT_MAX, LAT_DELTA):
    for lon in np.arange(LON_MIN, LON_MAX, LON_DELTA):
        print(f"lat: {lat:6} lon: {lon:6}", end="")

        response = requests.get(f'https://postboxes.dracos.co.uk/nearest.php?t=1&bounds={lon},{lat},{lon+LON_DELTA},{lat+LAT_DELTA}', headers=headers)
        reponse = response.json()

        print(" ->", len(reponse))
        postboxes.extend(reponse)

        time.sleep(1)

postboxes = pd.DataFrame(
    postboxes,
    columns =[
        "postbox_code",
        "postal_code",
        "name",
        "address",
        "lat",
        "lon",
        "last_collection",
        "last_collection_saturday",
    ]
    )

# Sort by postbox code.
postboxes.sort_values("postbox_code", inplace=True)

# Remove (possible) duplcates.
postboxes.drop_duplicates(inplace=True)

postboxes.to_csv("postboxes.csv", quoting=csv.QUOTE_NONNUMERIC, index=False)
