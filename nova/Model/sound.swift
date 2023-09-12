import AVFoundation
import CoreMotion

class SoundManager {
    let audioEngine = AVAudioEngine()
    var soundDict: [Sound:AVAudioPlayer?] = [:]
    var soundPanPositions: [Sound: Float] = [:]
    
    init() {
        for sound in Sound.allCases {
            soundDict[sound] = getAudioPlayer(sound: sound)
        }
    }

    private func getAudioPlayer(sound: Sound) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(
            forResource: sound.rawValue,
            withExtension: ".mp3"
        ) else {
            print("Fail to get url for \(sound)")
            return nil
        }

        var audioPlayer: AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            return audioPlayer
        } catch {
            print("Fail to load \(sound)")
            return nil
        }
    }
    
    func playLoop(sound: Sound) {
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }
    
    func play(sound: Sound) {
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.play()
    }
    
    func pause(sound: Sound) {
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.pause()
    }
    
    func lowVolume(sound: Sound) {
        var count = 0
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            count+=1
            audioPlayer.volume -= 0.1
            if count == 3{
                timer.invalidate()
            }
        }
    }
    
    func riseVolume(sound: Sound) {
        var count = 0
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            count+=1
            if audioPlayer.volume.isLessThanOrEqualTo(1.0){
                audioPlayer.volume += 0.1
            }
            if count == 7{
                timer.invalidate()
            }
        }
    }
    
    func stop(sound: Sound) {
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.currentTime = 0
        audioPlayer.pause()
    }
    
    func left(sound: Sound){
        var count = 0
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            count+=1
            audioPlayer.pan -= 0.1
            if count == 7{
                self.recover(sound: sound, direction: "left")
                print("Esquerda")
                timer.invalidate()
            }
        }
    }
    
    func leftAlt(sound: Sound){
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.pan = -0.6
    }
    
    func rightAlt(sound: Sound){
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.pan = 0.7
    }
    
    func recoverAlt(sound: Sound){
        var count = 0
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        
        print("Pan Inicial do \(sound.rawValue): \(audioPlayer.pan)")
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            count+=1
            
            if round(audioPlayer.pan) < 0.0{
                audioPlayer.pan += 0.1
            }else if round(audioPlayer.pan) > 0.0{
                audioPlayer.pan -= 0.1
            }else{
                audioPlayer.pan = 0.0
                print("Recover Final do \(sound.rawValue): \(audioPlayer.pan)")
                timer.invalidate()
            }
            
        }
    }
    
    func recover(sound: Sound, direction: String){
        var count = 0
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            count+=1
            if direction == "right"{
                audioPlayer.pan -= 0.12
            }else{
                audioPlayer.pan += 0.1
            }
            
            if count == 7{
                timer.invalidate()
            }
        }
    }
    
    func right(sound: Sound){
        var count = 0
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            count+=1
            audioPlayer.pan += 0.12
            if count == 7{
                print("Direita")
                self.recover(sound: sound, direction: "right")
                timer.invalidate()
            }
        }
    }
    
    func swipe(sound: Sound){
        var runCount = 0
        
        print("Começou")
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            print("Timer: \(timer)")
            runCount += 1

            if runCount == 5 {
                print("Musica Parada")
                timer.invalidate()
                self.stop(sound: sound)
            }
        }
    }
    
    enum Sound: String, CaseIterable {
        case base1
        case base2
        case piano
        case swipeF
        case long
        case rootNote
    }
}
