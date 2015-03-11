import QtQuick 2.4

Item {
    property var mainWindow
    property var simpleWindow
    property var miniWindow

    function initConnect(){
        Web360ApiWorker.playUrl.connect(playMusic);

        MediaPlayer.positionChanged.connect(updateSlider);
        MediaPlayer.positionChanged.connect(updateMusicTime);
        MediaPlayer.stateChanged.connect(updatePlayButton);
        MediaPlayer.mediaStatusChanged.connect(updateMusic);
        MediaPlayer.volumeChanged.connect(updateVolumeSlider);
        MediaPlayer.playbackModeChanged.connect(updateCycleButton);
        MediaPlayer.musicInfoChanged.connect(updateMusicInfo);

        MediaPlayer.setPlaylistByName(ConfigWorker.lastPlaylistName)
        MediaPlayer.mediaChanged(ConfigWorker.lastPlayedUri)
        MediaPlayer.volumeChanged(ConfigWorker.volume);
        MediaPlayer.setPlaybackMode(ConfigWorker.playbackMode);

    }

    function playMusic(result){
        MediaPlayer.stop()
        MediaPlayer.setOnlineMediaUrl(result.playlinkUrl);
        MediaPlayer.playToggle(true)
        updateMusicInfo(result.songName, result.singerName)
    }

    function updateSlider(position) {
        var rate = position / MediaPlayer.duration;

        mainWindow.playBottomBar.slider.updateSlider(rate);
        simpleWindow.playBottomBar.slider.updateSlider(rate);
        miniWindow.slider.updateSlider(rate);
    }

    function updateMusicTime(position){
        mainWindow.playBottomBar.updatePlayTime(MediaPlayer.positionString + '/' + MediaPlayer.durationString);
        simpleWindow.playBottomBar.updatePlayTime(MediaPlayer.positionString + '/' + MediaPlayer.durationString);
    }

    function audioAvailableChange(available)
    {
        print('audioAvailableChanged---------')
    }

    function updateMusicInfo(title, artist)
    {
        mainWindow.playBottomBar.updateMusicName(title);
        mainWindow.playBottomBar.updateArtistName(artist);
        
        simpleWindow.playBottomBar.updateMusicName(title);
        simpleWindow.playBottomBar.updateArtistName(artist);
    }


    function updateMusic(status){
        print('mediaStatusChanged', status)
        if (status == 3 || status==6) {
            print('The current media has been loaded')
        }
    }


    function updatePlayButton(state) {
        if (state == 0){
            onStopped();
        }else if (state == 1){
            onPlaying();
        }else if (state == 2){
            onPaused();
        }
    }

    function onPlaying(){
        mainWindow.playBottomBar.playing = true;
        simpleWindow.playBottomBar.playing = true;
        miniWindow.playing = true;
        console.log('Playing');
    }

    function onPaused(){
        mainWindow.playBottomBar.playing = false;
        simpleWindow.playBottomBar.playing = false;
        miniWindow.playing = false;
        console.log('Paused')
    }

    function onStopped(){
        mainWindow.playBottomBar.playing = false;
        simpleWindow.playBottomBar.playing = false;
        miniWindow.playing = false;
        console.log('Stopped')
    }

    function resetSkin() {
        playBottomBar.color = "#282F3F"
        bgImage.source = ''
    }

    function updateVolumeSlider(value){
        mainWindow.playBottomBar.volumeSlider.value = value / 100;
        simpleWindow.playBottomBar.volumeSlider.value = value / 100;
    }

    function updateCycleButton(value){
        mainWindow.playBottomBar.cycleButton.playbackMode = value;
        simpleWindow.playBottomBar.cycleButton.playbackMode = value;
    }

    function setSkinByImage(url) {
        if (url === undefined){
            url = "../skin/images/bg2.jpg"
        }
        playBottomBar.color = "transparent"
        bgImage.source = url
    }


    Connections {
        target: mainWindow.playBottomBar.slider
        onSliderRateChanged:{
            if (MediaPlayer.seekable){
                MediaPlayer.setPosition(MediaPlayer.duration * rate)
            }
        }
    }

    Connections {
        target: simpleWindow.playBottomBar.slider
        onSliderRateChanged:{
            if (MediaPlayer.seekable){
                MediaPlayer.setPosition(MediaPlayer.duration * rate)
            }
        }
    }

    Connections {
        target: miniWindow.slider
        onSliderRateChanged:{
            if (MediaPlayer.seekable){
                MediaPlayer.setPosition(MediaPlayer.duration * rate)
            }
        }
    }

    Connections {
        target: mainWindow.playBottomBar

        onPreMusic: MediaPlayer.previous()

        onPlayed: MediaPlayer.playToggle(isPlaying)

        onNextMusic: MediaPlayer.next()

        onVolumeChanged: {
            MediaPlayer.setVolume(parseInt(value * 100));
        }

        onMuted: {
            MediaPlayer.setMuted(muted);
            simpleWindow.playBottomBar.volumeButton.switchflag = !muted;
        }

        onPlaybackModeChanged:{
            MediaPlayer.setPlaybackMode(playbackMode);
            simpleWindow.playBottomBar.cycleButton.playbackMode = playbackMode;
        }
    }

    Connections {
        target: simpleWindow.playBottomBar

        onPreMusic: MediaPlayer.previous()

        onPlayed: MediaPlayer.playToggle(isPlaying)

        onNextMusic: MediaPlayer.next()

        onVolumeChanged: {
            MediaPlayer.setVolume(parseInt(value * 100))
        }
        onMuted: {
            MediaPlayer.setMuted(muted);
            mainWindow.playBottomBar.volumeButton.switchflag = !muted;
        }

        onPlaybackModeChanged:{
           MediaPlayer.setPlaybackMode(playbackMode);
           mainWindow.playBottomBar.cycleButton.playbackMode = playbackMode;
        }
    }

    Connections {
        target: miniWindow

        onPreMusic: MediaPlayer.previous()

        onPlayed: MediaPlayer.playToggle(isPlaying)

        onNextMusic: MediaPlayer.next()
    }

    Component.onCompleted: {
        initConnect();
    }
}
