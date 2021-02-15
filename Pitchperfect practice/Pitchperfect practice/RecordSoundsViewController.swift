//
//  RecordSoundsViewController.swift
//  Pitchperfect practice
//
//  Created by Isobel Ferris on 25/01/2021.
//


import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecord: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Function for enabling and disabling buttons when recording or not recording
    
    func configureUI (isRecording: Bool, isNotRecording: Bool) {
        stopRecord.isEnabled = !isRecording
        recordButton.isEnabled = !isNotRecording
        recordingLabel.text = !isRecording ? "Recording in Progress":"Tap to Record"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(isRecording: true, isNotRecording: false)
        print("viewWillAppear called")
    }
   
    @IBAction func recordAudio(_ sender: Any) {
       configureUI(isRecording: false, isNotRecording: true)

            
// MARK: Audio Recorder Delegate

    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
    let recordingName = "recordedVoice.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)

    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

    try! audioRecorder = AVAudioRecorder(url: filePath!,
    settings: [:])
        audioRecorder.delegate = self
    audioRecorder.isMeteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
    
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false, isNotRecording: true)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    } else {
    print("recording was not successful")
    }

}
    
    // Transition to playSoundsViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! playSoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        
        }
    }

}
