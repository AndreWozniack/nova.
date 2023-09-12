import AVFoundation
import CoreMotion

class SoundManager {
    let audioEngine = AVAudioEngine()
    var soundDict: [Sound:AVAudioPlayer?] = [:]
    var soundPanPositions: [Sound: Float] = [:]

    let audioEnvironment = AVAudioEnvironmentNode()
    
    func calculatePanPositionFromOrientation(_ orientation: CMQuaternion) -> Float {
        // Aqui, você pode calcular a posição de pan com base na orientação angular.
        // Por exemplo, você pode usar a inclinação (pitch) ou guinada (yaw) para ajustar a posição de pan.
        // Lembre-se de mapear os valores para o intervalo -1.0 a 1.0, que representa o espectro completo de pan.
        
        // Para um exemplo simples, você pode usar a guinada (yaw) para ajustar a posição de pan.
        let yaw = Float(atan2(2.0 * (orientation.y * orientation.w + orientation.x * orientation.z), 1.0 - 2.0 * (orientation.y * orientation.y + orientation.x * orientation.x)))
        
        // Mapeie o valor de guinada (yaw) para o intervalo -1.0 a 1.0
        let panPosition = (yaw / Float.pi)
        
        return panPosition
    }

    
    init() {
        for sound in Sound.allCases {
            soundDict[sound] = getAudioPlayer(sound: sound)
        }

//        // Inicialize a posição de pan com base na orientação atual do dispositivo
//        if let motion = motionManager.deviceMotion {
//            let orientation = CMQuaternion(x: motion.attitude.quaternion.x, y: motion.attitude.quaternion.y, z: motion.attitude.quaternion.z, w: motion.attitude.quaternion.w)
//            let panPosition = calculatePanPositionFromOrientation(orientation)
//            
//            for sound in Sound.allCases {
//                guard let audioPlayer = soundDict[sound] else { continue }
//                audioPlayer!.pan = panPosition
//                soundPanPositions[sound] = panPosition
//            }
//        }
//        
//        audioEnvironment.renderingAlgorithm = .auto
//        audioEngine.attach(audioEnvironment)
//        audioEngine.connect(audioEnvironment, to: audioEngine.mainMixerNode, format: nil)
//        audioEnvironment.listenerPosition = AVAudioMake3DPoint(0, 0, 0)
//        
//        do {
//            try audioEngine.start()
//        } catch {
//            print("Erro ao iniciar o mecanismo de áudio: \(error)")
//        }
    }

    
    let motionManager = CMMotionManager()

    
    func calculatePanPositionFromGyroData(_ gyroData: CMGyroData) -> Float {
        // Use os dados do giroscópio para calcular a posição de pan com sensibilidade reduzida.
        let yaw = Float(gyroData.rotationRate.y)
        
        // Reduza a sensibilidade dividindo o valor de rotação por um fator de escala menor (por exemplo, 10.0).
        let panPosition = (yaw / 10.0) // Ajuste o fator de escala conforme necessário.
        
        return panPosition
    }




    func startMotionUpdates() {
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.01
            motionManager.startGyroUpdates(to: .main) { (gyroData, error) in
                guard let gyroData = gyroData else { return }

                // Use os dados do giroscópio para calcular a posição de pan
                let panPosition = self.calculatePanPositionFromGyroData(gyroData)

                // Atualize a posição de pan para cada som
                for sound in Sound.allCases {
                    guard let audioPlayer = self.soundDict[sound] else { continue }

                    // Defina a posição de pan
                    audioPlayer!.pan = panPosition

                    // Atualize a posição de pan no dicionário
                    self.soundPanPositions[sound] = panPosition
                }
            }
            print("Gyro habilitado")
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
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.volume = 0.3
    }
    
    func riseVolume(sound: Sound) {
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.volume = 1.0
    }
    
    func stop(sound: Sound) {
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.currentTime = 0
        audioPlayer.pause()
    }
    
    func left(sound: Sound){
        var count = 0
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            count+=1
            audioPlayer.pan -= 0.1
            if count == 7{
                self.recover(sound: sound, direction: "left")
                print("Esquerda")
                timer.invalidate()
            }
        }
    }
    
    func recover(sound: Sound, direction: String){
        var count = 0
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
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
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
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
