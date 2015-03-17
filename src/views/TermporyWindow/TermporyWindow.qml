import QtQuick 2.4
import DMusic 1.0
import "../DMusicWidgets"

DRectWithCorner {
    id: termporyWindow

    property var playlistView: playlistView
    property var models
    property var currentIndex: -1

    rectWidth: 302
    rectHeight: 402 + 12
    withBlur: false
    rectRadius: 0
    fillColor: "transparent"
    blurColor: "transparent"
    borderColor: "transparent"
    blurRadius: 0
    blurWidth: 4
    cornerPos: 257
    cornerWidth: 20
    cornerHeight: 10
    color: "transparent"

    Component {
        id: musicDelegate
        MusicDelegate {}
    }

    Column{

        height: 402

        Rectangle{
            id: titleBar
            width: termporyWindow.width
            height: 34
            color: "white"

            Row {
                anchors.centerIn: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14

                Text{
                    id: playlistName
                    width: titleBar.width - 28 - deleteButton.width - closeButton.width
                    height: 25
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 16
                    color: "#676767"
                    text: '正在播放'

                    Text {
                        x: playlistName.contentWidth
                        width: 40
                        height: 25
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 16
                        color: "#a0a0a0"
                        text: {
                            var playlist = MediaPlayer.playlist;
                            if (playlist){
                                return '(' + playlist.count + ')';
                            }else{
                                return '';
                            }
                        }
                    }
                }

                DDeleteButton {
                    id: deleteButton
                    width: 25
                    height: 25
                }

                DCloseButton {
                    id: closeButton
                    width: 25
                    height: 25
                }

            }
        }

        Rectangle {
            id: separator
            height: 1
            width: termporyWindow.width
            color: "transparent"
            Rectangle{
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                color: "lightgray"
            }
        }

        Rectangle {
            id: playlistContainer
            height: 402 - titleBar.height - separator.height
            width: termporyWindow.width

            border.color: 'green'
            border.width: 1
            ListView {
                id: playlistView
                anchors.fill: playlistContainer
                topMargin: 10
                bottomMargin: 10
                // flickingVertically: false
                // boundsBehavior: Flickable.DragOverBounds
                // pressDelay: 0
                maximumFlickVelocity: 10000
                highlightMoveVelocity: 10000

                preferredHighlightBegin: 0
                preferredHighlightEnd: 34
                highlightRangeMode: ListView.ApplyRange

                model: {
                    var playlist = MediaPlayer.playlist;
                    if (playlist){
                        return playlist.medias;
                    }else{
                        return null;
                    }
                }
                delegate: musicDelegate
                currentIndex: {
                    var playlist = MediaPlayer.playlist;
                    if (playlist){
                        return playlist.currentIndex;
                    }else{
                        return -1;
                    }
                }
                focus: true
                spacing: 8
                displayMarginBeginning: -24
                displayMarginEnd: -24
                snapMode:ListView.SnapToItem

                signal changeIndex(int index)

                DScrollBar {
                    flickable: parent
                    inactiveColor: 'black'
                }
            }
        }
    }
}