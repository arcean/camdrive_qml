function createObject(sourceFile, parentObject) {
    var component = Qt.createComponent(sourceFile);
    var guiObject = component.createObject(parentObject);

    if (guiObject == null) {
        console.log("Error creating object");
    }
    else {
        return guiObject
    }
}

function cloneObject(objectToClone) {
    var clone = {};
    for (var attribute in objectToClone) {
        clone[attribute] = objectToClone[attribute];
    }
    return clone;
}

function cloneVideoObject(video, itemId) {
    var videoItem = {};
    if (itemId) {
        videoItem["itemId"] = itemId;
    }
    else {
        videoItem["itemId"] = video.itemId;
    }
    videoItem["title"] = video.title;
    videoItem["fileName"] = video.fileName;
    videoItem["name"] = video.title;
    videoItem["url"] = video.url;
    videoItem["filePath"] = video.filePath;
    videoItem["duration"] = video.duration;
    return videoItem;
}

