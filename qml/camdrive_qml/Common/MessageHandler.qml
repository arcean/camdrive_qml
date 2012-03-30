import QtQuick 1.1
import com.nokia.extras 1.0

InfoBanner {
    id: infoBanner
    anchors.top: parent.top; anchors.topMargin: 40

    function showMessage(message) {
        infoBanner.text = message;
        infoBanner.show();
    }
}
