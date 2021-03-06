/*
*  Copyright 2020  Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.7

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.latte.core 0.2 as LatteCore

Item {
    property Item destination: null

    readonly property int headThickness: destination ? destination.headThicknessMargin : appletItem.metrics.margin.thickness
    readonly property int tailThickness: destination ? destination.tailThicknessMargin : appletItem.metrics.margin.thickness
    readonly property int thickness: headThickness + tailThickness + (root.isHorizontal ? destination.height : destination.width)
    readonly property int lengthPadding: {
        if ( (root.myView.alignment === LatteCore.Types.Justify && appletItem.firstChildOfStartLayout)
                || (root.myView.alignment === LatteCore.Types.Justify && appletItem.lastChildOfEndLayout)
                || (root.myView.alignment !== LatteCore.Types.Justify && appletItem.firstChildOfMainLayout)
                || (root.myView.alignment !== LatteCore.Types.Justify && appletItem.lastChildOfMainLayout)) {
            //! Fitts Law on corners
            return appletItem.lengthAppletFullMargin;
        }

        return appletItem.lengthAppletPadding;
    }

    readonly property bool active: parent ? parent.active : false


    Loader{
        anchors.fill: parent
        active: appletItem.debug.eventsSinkEnabled && active

        sourceComponent: Rectangle {
            anchors.fill: parent
            color: "yellow"
            opacity: 0.2
            visible: root.latteView && root.latteView.sink.destinationItem === destination
        }
    }

    Item {
        id: originParentItem
        anchors.fill: parent

        //! NOTICE: Do not add any more child items. These child items are used from SinkedEvents handler in order
        //! to identify the areas from which mouse events should be sunk into the destination item

        EventsSinkOriginArea {
            id: topArea
            width: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? destination.width + 2 * lengthPadding : thickness
            height: {
                if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
                    return lengthPadding;
                } else if (plasmoid.location === PlasmaCore.Types.TopEdge) {
                    return tailThickness;
                } else {
                    return headThickness;
                }
            }

            states:[
                State{
                    name: "horizontal"
                    when: plasmoid.formFactor === PlasmaCore.Types.Horizontal

                    AnchorChanges{
                        target: topArea;
                        anchors.horizontalCenter: parent.horizontalCenter; anchors.verticalCenter: undefined;
                        anchors.right: undefined; anchors.left: undefined; anchors.top: undefined; anchors.bottom: parent.top;
                    }
                },
                State{
                    name: "vertical"
                    when: plasmoid.formFactor === PlasmaCore.Types.Vertical

                    AnchorChanges{
                        target: topArea;
                        anchors.horizontalCenter: undefined; anchors.verticalCenter: undefined;
                        anchors.right: undefined; anchors.left: leftArea.left; anchors.top: leftArea.top; anchors.bottom: undefined;
                    }
                }
            ]
        }

        EventsSinkOriginArea {
            id: bottomArea
            width: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? destination.width + 2 * lengthPadding : thickness
            height: {
                if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
                    return lengthPadding;
                } else if (plasmoid.location === PlasmaCore.Types.BottomEdge) {
                    return tailThickness;
                } else {
                    return headThickness;
                }
            }

            states:[
                State{
                    name: "horizontal"
                    when: plasmoid.formFactor === PlasmaCore.Types.Horizontal

                    AnchorChanges{
                        target: bottomArea;
                        anchors.horizontalCenter: parent.horizontalCenter; anchors.verticalCenter: undefined;
                        anchors.right: undefined; anchors.left: undefined; anchors.top: parent.bottom; anchors.bottom: undefined;
                    }
                },
                State{
                    name: "vertical"
                    when: plasmoid.formFactor === PlasmaCore.Types.Vertical

                    AnchorChanges{
                        target: bottomArea;
                        anchors.horizontalCenter: undefined; anchors.verticalCenter: undefined;
                        anchors.right: undefined; anchors.left: leftArea.left; anchors.top: undefined; anchors.bottom: leftArea.bottom;
                    }
                }
            ]
        }

        EventsSinkOriginArea {
            id: leftArea
            height: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? thickness : destination.height + 2 * lengthPadding
            width: {
                if (plasmoid.formFactor === PlasmaCore.Types.Horizontal) {
                    return lengthPadding;
                } else if (plasmoid.location === PlasmaCore.Types.LeftEdge) {
                    return tailThickness;
                } else {
                    return headThickness;
                }
            }

            states:[
                State{
                    name: "horizontal"
                    when: plasmoid.formFactor === PlasmaCore.Types.Horizontal

                    AnchorChanges{
                        target: leftArea;
                        anchors.horizontalCenter: undefined; anchors.verticalCenter: undefined;
                        anchors.right: undefined; anchors.left: bottomArea.left; anchors.top: undefined; anchors.bottom: bottomArea.bottom;
                    }
                },
                State{
                    name: "vertical"
                    when: plasmoid.formFactor === PlasmaCore.Types.Vertical

                    AnchorChanges{
                        target: leftArea;
                        anchors.horizontalCenter: undefined; anchors.verticalCenter: parent.verticalCenter;
                        anchors.right: parent.left; anchors.left: undefined; anchors.top: undefined; anchors.bottom: undefined;
                    }
                }
            ]
        }

        EventsSinkOriginArea {
            id: rightArea
            height: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? thickness : destination.height + 2 * lengthPadding
            width: {
                if (plasmoid.formFactor === PlasmaCore.Types.Horizontal) {
                    return lengthPadding;
                } else if (plasmoid.location === PlasmaCore.Types.RightEdge) {
                    return tailThickness;
                } else {
                    return headThickness;
                }
            }

            states:[
                State{
                    name: "horizontal"
                    when: plasmoid.formFactor === PlasmaCore.Types.Horizontal

                    AnchorChanges{
                        target: rightArea;
                        anchors.horizontalCenter: undefined; anchors.verticalCenter: undefined;
                        anchors.right: bottomArea.right; anchors.left: undefined; anchors.top: undefined; anchors.bottom: bottomArea.bottom;
                    }
                },
                State{
                    name: "vertical"
                    when: plasmoid.formFactor === PlasmaCore.Types.Vertical

                    AnchorChanges{
                        target: rightArea;
                        anchors.horizontalCenter: undefined; anchors.verticalCenter: parent.verticalCenter;
                        anchors.right: undefined; anchors.left: parent.right; anchors.top: undefined; anchors.bottom: undefined;
                    }
                }
            ]
        }
    }
}
