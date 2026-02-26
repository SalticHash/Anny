from os import listdir
from pathlib import Path
from json import dump
charachters = {}
for gif in listdir("./sprites/"):
    file = Path("./sprites/" + gif)
    if file.suffix != ".gif": continue
    charachters[file.stem] = {
        "raw_name": file.stem,
        "name": file.stem.replace("_", " ").title(),
        "animation": str("./sprites/" + file.stem + ".gif"),
        "thumb": str("./sprites/thumb/" + file.stem + ".jpg"),
        "desc": ""
    }
for gif in listdir("./sprites/letters/"):
    file = Path("./sprites/letters/" + gif)
    if file.suffix != ".gif": continue
    charachters[file.stem] = {
        "raw_name": file.stem,
        "name": file.stem.replace("_", " ").title(),
        "animation": str("./sprites/letters/" + file.stem + ".gif"),
        "thumb": str("./sprites/letters/thumb/" + file.stem + ".jpg"),
        "desc": ""
    }

# Will delete all descriptions  
# with open("zout.json", "w") as fp:
#     dump(charachters, fp)

print(charachters)