//
//  FilterGraphView.swift
//  Mixer
//
//  Created by y on 17/5/3.
//  Copyright © 2017年 y. All rights reserved.
//

import UIKit

class DataModel: NSObject {
    static let peqQTable: [Float] = [0.50, 0.53, 0.56, 0.59, 0.63, 0.67, 0.71, 0.75, 0.79, 0.84, 0.89, 0.94, 1.00,
                                     1.06, 1.12, 1.19, 1.26, 1.30, 1.40, 1.50, 1.60, 1.70, 1.80, 1.90, 2.00, 2.10,
                                     2.20, 2.40, 2.50, 2.70, 2.80, 3.00, 3.20, 3.40, 3.60, 3.80, 4.00, 4.20, 4.50,
                                     4.80, 5.00, 5.30, 5.70, 6.00, 6.30, 6.70, 7.10, 7.60, 8.00, 8.50, 9.00, 9.50,
                                     10.10, 10.70, 11.30, 12.00, 12.70, 13.50, 14.00, 15.00, 16.00, 17.00, 18.00, 19.00, 20.00]
}

@objc protocol FilterGraphViewDelegate: NSObjectProtocol {
    func filterGraphViewHPFilterChanged(freq: Float)
    func filterGraphViewLPFilterChanged(freq: Float)
    func filterGraphViewPEQFilterBandChoosed(band: Int)
    func filterGraphViewPEQFilterChanged(band: Int, freq: Float, gain: Float)
    func filterGraphViewPEQFilterChanged(band: Int, qIndex: Int, qValue: Float)
}
@IBDesignable
class FilterGraphView: UIView {
    private static let NF = 420
    private static let MAX_EQ_BAND = 16//定义EQ段数
    
    private struct complex {
        var real: Double
        var imag: Double
    }
    
    enum hlpf_type: Int {
        case type_Bessel = 0
        case type_Butterworth = 1
        case type_LinkRiley = 2
    }
    
    enum hlpf_slope: Int {
        case slope_6dB = 0
        case slope_12dB = 1
        case slope_18dB = 2
        case slope_24dB = 3
        case slope_36dB = 4
        case slope_48dB = 5
    }
    
    // eq_type
    enum filter_type: UInt8 {
        case type_PEQ = 0
        case type_lowShelf = 1
        case type_highShelf = 2
    }
    
    private static let PI = 3.1415926535897931
    private static let Fs = 192000 //采样率必须高点，在高频处才不会变得怪怪的
    private static let N = 960000 //频率响应曲线的点数  频率分辨率才能达到: 192k/960k/2 = 0.1Hz
    
    //17行, 0~16 : music eq1~eq7, fir 1~10  17:所有曲线和
    
    private static let lb: Int = 3
    private static let la: Int = 3
    //Slope: 0：-6dB  1：-12dB  2：-18dB  3：-24dB  4：-36dB  5：-48dB
    private static let numSectionsbuf: [Int] = [1, 2, 3, 4, 6, 8]
    
    //Type: 0: Bessel;  1:Butterworth;  2:Link-Riley
    //Slope: 0：-6dB  1：-12dB  2：-18dB  3：-24dB  4：-36dB  5：-48dB
    private static let Qbuf: [[Float]] =
        [
            //Bessel
            [0.5773,0,0,0,0],//order 2
            [0.6910,0,0,0,0],//order 3
            [0.5219, 0.8055,0,0,0],//order 4
            [0.5103, 0.6112, 1.0234,0,0],//order 6
            [0.5060, 1.2258, 0.7109, 0.5596,0],//order 8
            
            //Butterworth
            [0.7071,0,0,0,0],//order 2
            [1.0000,0,0,0,0],//order 3
            [0.5412, 1.3065,0,0,0],//order 4
            [0.5177, 0.7071, 1.9320,0,0],//order 6
            [0.5098, 0.6013, 0.8999, 2.5628,0],//order 8
            
            //Link-Riley
            [0.50,0,0,0,0],//order 2
            [0.60,0,0,0,0],//Link-Riley no "order 3"
            [0.71, 0.71,0,0,0],//order 4
            [0.50, 1.00, 1.00,0,0],//order 6
            [0.54, 1.34, 0.54, 1.34,0],//order 8
    ]
    
    private static let FreqTable: [Double] = [
        10, 10.2, 10.4, 10.6, 10.8, 11, 11.3, 11.5, 11.7, 11.9, 12.2, 12.4, 12.6, 12.9, 13.1, 13.4, 13.7, 13.9,
        14.2, 14.5, 14.7, 15, 15.3, 15.6, 15.9, 16.2, 16.6, 16.9, 17.2, 17.5, 17.9, 18.2, 18.6, 18.9, 19.3,
        19.7, 20.1, 20.5, 20.9, 21.3, 21.7, 22.1, 22.5, 23.0, 23.4, 23.9, 24.3, 24.8, 25.3, 25.8, 26.3, 26.8,
        27.3, 27.8, 28.4, 28.9, 29.5, 30.1, 30.7, 31.3, 31.9, 32.5, 33.1, 33.8, 34.4, 35.1, 35.8, 36.5, 37.2,
        37.9, 38.6, 39.4, 40.1, 40.9, 41.7, 42.5, 43.4, 44.2, 45.1, 45.9, 46.8, 47.7, 48.7, 49.6, 50.6, 51.6,
        52.6, 53.6, 54.6, 55.7, 56.8, 57.9, 59.0, 60.1, 61.3, 62.5, 63.7, 65.0, 66.2, 67.5, 68.8, 70.2, 71.5,
        72.9, 74.3, 75.8, 77.2, 78.7, 80.3, 81.8, 83.4, 85.0, 86.7, 88.4, 90.1, 91.9, 94.0, 95.0, 97.0, 99.0,
        101, 103, 105, 107, 109, 111, 114, 116, 118, 120, 123, 125, 127, 130, 132, 135, 138, 140, 143, 146, 149,
        152, 154, 157, 161, 164, 167, 170, 173, 177, 180, 184, 187, 191, 195, 198, 202, 206, 210, 214, 218, 223,
        227, 231, 236, 241, 245, 250, 255, 260, 265, 270, 275, 281, 286, 292, 297, 303, 309, 315, 321, 327, 334,
        340, 347, 354, 360, 367, 375, 382, 389, 397, 405, 412, 420, 429, 437, 445, 454, 463, 472, 481, 490, 500,
        510, 520, 530, 540, 551, 561, 572, 583, 595, 606, 618, 630, 642, 655, 667, 680, 694, 707, 721, 735, 749,
        764, 779, 794, 809, 825, 841, 857, 874, 891, 908, 926, 944, 962, 981, 1000,
        1020, 1040, 1060, 1080, 1100, 1120, 1140, 1170, 1190, 1210, 1240, 1260, 1280, 1310, 1330, 1360, 1390,
        1410, 1440, 1470, 1500, 1530, 1560, 1590, 1620, 1650, 1680, 1710, 1750, 1780, 1820, 1850, 1890, 1920,
        1960, 2000, 2040, 2080, 2120, 2160, 2200, 2240, 2290, 2330, 2380, 2420, 2470, 2520, 2570, 2620, 2670,
        2720, 2770, 2830, 2880, 2940, 3000, 3050, 3110, 3170, 3240, 3300, 3360, 3430, 3500, 3560, 3630, 3700,
        3780, 3850, 3920, 4000, 4080, 4160, 4240, 4320, 4400, 4490, 4580, 4670, 4760, 4850, 4940, 5040, 5140,
        5240, 5340, 5440, 5550, 5660, 5770, 5880, 5990, 6110, 6230, 6350, 6470, 6600, 6730, 6860, 6990, 7130,
        7270, 7410, 7550, 7700, 7850, 8000, 8160, 8310, 8480, 8640, 8810, 8980, 9150, 9330, 9510, 9700, 9890,
        10100, 10300, 10500, 10700, 10900, 11100, 11300, 11500, 11800, 12000, 12200, 12500, 12700, 12900,
        13200, 13500, 13700, 14000, 14300, 14500, 14800, 15100, 15400, 15700, 16000, 16300, 16600, 17000,
        17300, 17600, 18000, 18300, 18700, 19000, 19400, 19800, 20200, 20600, 21000, 21400, 21800,
        22200, 22600, 23100, 23500, 24000, 24400, 24900, 25400, 25900, 26400, 26900, 27400, 28000, 28500, 29100, 29600, 30200, 30800, 31400, 32000]
    
    // 最大长度MAX_EQ_BAND
    private static let def_freq: [Int] = [
        40,60,80,100,200,300,400,500,600,700,800,
        900,1000,2000,3000,4000
    ]
    
    private let bgCor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
    private let gridCor = UIColor(red: 255/255.0, green: 180/255.0, blue: 0/255.0, alpha: 1.0)
    private let scaleCor = UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1.0)//UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
    private let curveCor = UIColor(red: 45.0/255.0, green: 255.0/255.0, blue: 254.0/255.0, alpha: 1.0)//UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    private let movePointFillColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    private let movePointHighlightedStrokeColor = UIColor(red: 43.0/255.0, green: 225.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    
    // 可拖拽的增益范围
    private let m_validMaxdB = 15
    private let m_validMindB = -15
    
    // 可视的增益范围
    private var m_maxdB = 20
    private var m_mindB = -20
    
    // 可拖拽的频率范围
    private let m_validLowFreq: Float = 20
    private let m_validHighFreq: Float = 20000
    
    // 可视的频率范围
    private let m_lowFreq: Float = 10
    private let m_highFreq: Float = 24000
    private var hpf_freq: Float = 20
    private var hpf_type = hlpf_type.type_Bessel
    private var hpf_slope = hlpf_slope.slope_6dB
    private var hpf_byp = true
    private var lpf_freq: Float = 20000
    private var lpf_type = hlpf_type.type_Bessel
    private var lpf_slope = hlpf_slope.slope_6dB
    private var lpf_byp = true
    
    private var eq_byp = [Bool](repeating: false, count: MAX_EQ_BAND)
    private var eq_type = [UInt8](repeating: 0, count: MAX_EQ_BAND)
    private var eq_freq = [Float](repeating: 0.0, count: MAX_EQ_BAND)
    private var eq_gain = [Float](repeating: 0.0, count: MAX_EQ_BAND)
    private var eq_Q = [Float](repeating: 0.0, count: MAX_EQ_BAND)
    
    private var bPressed = [Bool](repeating: false, count: MAX_EQ_BAND+2)
    private var m_peqBand: Int = 0
    
    private var m_borderRect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    private var m_moveRect = [CGRect](repeating: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0), count: MAX_EQ_BAND+2)
    private var H = [Float](repeating: 0.0, count: NF)
    //分母和分子系数
    private var d_factor = [Double](repeating: 0.0, count: 3)
    private var n_factor = [Double](repeating: 0.0, count: 3)
    
    @objc weak var delegate: FilterGraphViewDelegate?
    
    private var pinchBandIndex: Int = -1
    private let pinchGestureBeganScale: CGFloat = 1.0
    private var pinchGestureLastScale: CGFloat = 1.0
    
    ///
    private var touch_moved_flag = false
    private var touched_move_point_i: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        additionnalInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        additionnalInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        additionnalInit()
    }
    
    override func draw(_ rect: CGRect) {
        paintGrid()
        paintScale()
        paintFreqCurve()
        paintMovePoint()
    }
    
    // 触摸开始处理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var lastX: CGFloat!
        var lastY: CGFloat!
        
        touch_moved_flag = false
        
        for touch in touches {
            let touchPoint = touch.location(in: self)
            lastX = touchPoint.x
            lastY = touchPoint.y
        }
        
        for i in 0 ..< (m_peqBand+2) {
            if (lastX>(m_moveRect[i].origin.x-5) && lastX<(m_moveRect[i].origin.x+m_moveRect[i].width+5) && lastY>(m_moveRect[i].origin.y-5) && lastY<(m_moveRect[i].origin.y+m_moveRect[i].height+5)) {
                bPressed[i] = true
                touched_move_point_i = i;
                
                break
            }
            else {
                bPressed[i] = false
            }
        }
        
        delegate?.filterGraphViewPEQFilterBandChoosed(band : touched_move_point_i);
    }
    
    // 触摸移动处理
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var lastX: CGFloat = 0.0
        var lastY: CGFloat = 0.0
        
        for touch in touches {
            let touchPoint = touch.location(in: self)
            lastX = touchPoint.x
            lastY = touchPoint.y
        }
        
        for i in 0 ..< (m_peqBand+2) {
            if bPressed[i] == true {
                if i == m_peqBand {
                    //高通
                    hpf_freq = Float(posToFreq(pos: Double(lastX) - Double(m_borderRect.origin.x)))
                    if (hpf_freq < m_validLowFreq) {
                        hpf_freq = m_validLowFreq
                    }
                    else if (hpf_freq > m_validHighFreq) {
                        hpf_freq = m_validHighFreq
                    }
                    
                    delegate?.filterGraphViewHPFilterChanged(freq: hpf_freq)
                }
                else if i == (m_peqBand + 1) {
                    //低通
                    lpf_freq = Float(posToFreq(pos: Double(lastX) - Double(m_borderRect.origin.x)))
                    if (lpf_freq < m_validLowFreq) {
                        lpf_freq = m_validLowFreq
                    }
                    else if (lpf_freq > m_validHighFreq) {
                        lpf_freq = m_validHighFreq
                    }
                    
                    delegate?.filterGraphViewLPFilterChanged(freq: lpf_freq)
                }
                else {
                    eq_freq[i] = Float(posToFreq(pos: Double(lastX) - Double(m_borderRect.origin.x)))
                    eq_gain[i] = Float(Double(m_maxdB) - (Double(lastY - m_borderRect.origin.y) * (Double(m_maxdB - m_mindB) / Double(m_borderRect.height))))
                    
                    if (eq_gain[i] > Float(m_validMaxdB)) {
                        eq_gain[i] = Float(m_validMaxdB)
                    }
                    else if (eq_gain[i] < Float(m_validMindB)) {
                        eq_gain[i] = Float(m_validMindB)
                    }
                    
                    if (eq_freq[i] < m_validLowFreq) {
                        eq_freq[i] = m_validLowFreq
                    }
                    else if (eq_freq[i] > m_validHighFreq) {
                        eq_freq[i] = m_validHighFreq
                    }
                    
                    delegate?.filterGraphViewPEQFilterChanged(band: i, freq: eq_freq[i], gain: eq_gain[i])
                }
                updateCurve()
                return
            }
        }
        
    }
    
    // 触摸释放处理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in 0 ..< (m_peqBand+2) {
            bPressed[i] = false
        }
    }
    
    // 额外的初始化
    private func additionnalInit() {
        for i in 0 ..< FilterGraphView.MAX_EQ_BAND {
            eq_freq[i] = Float(FilterGraphView.def_freq[i])
            eq_gain[i] = 0
            eq_Q[i] = 6.0
            eq_type[i] = filter_type.type_PEQ.rawValue
            eq_byp[i] = false
        }
        
        bPressed = Array<Bool>(repeating: false, count: FilterGraphView.MAX_EQ_BAND+2)
        m_peqBand = FilterGraphView.MAX_EQ_BAND
        
        m_moveRect = Array<CGRect>(repeating: CGRect(), count: FilterGraphView.MAX_EQ_BAND+2)
        
        H = Array<Float>(repeating: 0.0, count: FilterGraphView.NF)
        
        // 添加捏合手势
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(processPinchGesture))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func processPinchGesture(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            // 捏合手势开始，确定要控制的PEQ段号
            if gesture.numberOfTouches >= 2 {
                for i in 0 ..< m_peqBand+2 {
                    let startPos = gesture.location(ofTouch: 0, in: self)
                    let endPos = gesture.location(ofTouch: 1, in: self)
                    //print("\(startPos.x), \(endPos.x), \(m_moveRect[i].origin.x)")
                    if startPos.x > endPos.x {
                        if endPos.x <= m_moveRect[i].origin.x
                            && startPos.x >= (m_moveRect[i].origin.x+m_moveRect[i].width)
                            && i < m_peqBand {
                            for qIndex in 0 ..< DataModel.peqQTable.count {
                                if (DataModel.peqQTable[qIndex] == eq_Q[i]) {
                                    //print("control peq band\(i)")
                                    pinchBandIndex = i
                                    gesture.scale = pinchGestureBeganScale
                                    break
                                }
                            }
                            break
                        }
                    } else {
                        if startPos.x <= m_moveRect[i].origin.x
                            && endPos.x >= (m_moveRect[i].origin.x+m_moveRect[i].width)
                            && i < m_peqBand {
                            for qIndex in 0 ..< DataModel.peqQTable.count {
                                if (DataModel.peqQTable[qIndex] == eq_Q[i]) {
                                    //print("control peq band\(i)")
                                    pinchBandIndex = i
                                    gesture.scale = pinchGestureBeganScale
                                    break
                                }
                            }
                            break
                        }
                    }
                }
            }
        case .changed:
            // 捏合手势改变，计算与上一次差值offset
            if pinchBandIndex >= 0 {
                //print("control peq band\(pinchBandIndex), scale=\(gesture.scale)")
                let offset = Int((gesture.scale - pinchGestureLastScale)*100)
                if offset != 0 {
                    //print("offset=\(offset)")
                    for i in 0 ..< DataModel.peqQTable.count {
                        if DataModel.peqQTable[i] == eq_Q[pinchBandIndex] {
                            var newQIndex = i - offset
                            if newQIndex <= 0 {
                                newQIndex = 0
                                //print("min scale=\(gesture.scale)")
                            } else if newQIndex >= DataModel.peqQTable.count - 1 {
                                newQIndex = DataModel.peqQTable.count - 1
                                //print("max scale=\(gesture.scale)")
                            }
                            if i != newQIndex {
                                //print("setPEQ band=\(pinchBandIndex), \(newQIndex), \(DataModel.peqQTable[newQIndex])")
                                setPEQ(band: UInt8(pinchBandIndex), type: eq_type[pinchBandIndex], Q: DataModel.peqQTable[newQIndex])
                                delegate?.filterGraphViewPEQFilterChanged(band: pinchBandIndex, qIndex: newQIndex, qValue: DataModel.peqQTable[newQIndex])
                            }
                            
                            break
                        }
                    }
                    pinchGestureLastScale = gesture.scale
                }
            }
        case .ended:
            fallthrough
        case .cancelled:
            //print("end")
            pinchBandIndex = -1
            pinchGestureLastScale = pinchGestureBeganScale
        default:
            break
        }
    }
    
    // 点坐标限制在矩形里面
    private func CLIP_RGN(x: inout CGFloat, y: inout CGFloat, rect: CGRect) {
        if x < rect.origin.x {
            x = rect.origin.x
        }
        
        if x > (rect.origin.x + rect.width) {
            x = rect.origin.x + rect.width
        }
        
        if y < rect.origin.y {
            y = rect.origin.y
        }
        
        if y > (rect.origin.y + rect.height) {
            y = rect.origin.y + rect.height
        }
    }
    
    // 画背景和坐标系
    private func paintGrid() {
        var pos: Double
        var w: Double
        var p1: CGPoint = CGPoint(x: 0.0, y: 0.0)
        var p2: CGPoint = CGPoint(x: 0.0, y: 0.0)
        let m_rect: CGRect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let context = UIGraphicsGetCurrentContext()
        
        context?.saveGState()
        // 画背景框
        context?.setFillColor(bgCor.cgColor)
        context?.addRect(m_rect)
        context?.drawPath(using: .fill)
        
        // 画矩形框
        m_borderRect = CGRect(x: m_rect.origin.x + 40, y: m_rect.origin.y + 10, width: m_rect.origin.x + m_rect.width - 5 - 40, height: m_rect.origin.y + m_rect.height - 20 - 10)
        pos = Double(m_borderRect.height) / Double(8)
        context?.setStrokeColor(gridCor.cgColor)
        context?.addRect(m_borderRect)
        context?.drawPath(using: .stroke)
        
        // 画y轴坐标系
        for i in 0 ..< 7 {
            p1.x = m_borderRect.origin.x
            p1.y = m_borderRect.origin.y + CGFloat(Double(i+1)*pos)
            p2.x = m_borderRect.origin.x + m_borderRect.width
            p2.y = m_borderRect.origin.y + CGFloat(Double(i+1)*pos)
            context?.move(to: p1)
            context?.addLine(to: p2)
            context?.drawPath(using: .stroke)
        }
        
        // 画x轴坐标系
        w = Double(Double(m_borderRect.width)/Double(log10(m_highFreq)-log10(m_lowFreq)))
        var freq: Int = Int(m_lowFreq)
        repeat {
            pos = log10(Double(freq)) - log10(Double(m_lowFreq))
            if pos >= 0 {
                p1.x = m_borderRect.origin.x + CGFloat(pos*w)
                p1.y = m_borderRect.origin.y
                p2.x = m_borderRect.origin.x + CGFloat(pos*w)
                p2.y = m_borderRect.origin.y + m_borderRect.height
                context?.move(to: p1)
                context?.addLine(to: p2)
                context?.drawPath(using: .stroke)
            }
            freq += Int(pow(Double(10), Double(bitsOfNumber(value: freq))))
        } while (Float(freq) < m_highFreq)
        
        context?.restoreGState()
    }
    
    // 画比例尺：横纵坐标刻度值
    private func paintScale() {
        var db: Int
        //var string: String
        //var valFont:
        
        var m_rect: CGRect
        var pos: Double
        var f: Float
        var w: Float
        var drawPoint = CGPoint(x: 0.0, y: 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.saveGState()
        
        db = m_maxdB
        pos = Double(m_borderRect.height) / Double(8);
        m_rect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        // 绘制文字
        /*let font = UIFont.systemFont(ofSize: 8.0)
         let fontName = font.fontName as NSString
         let cgFont = CGFont(fontName)
         let copiedFont = cgFont!.copy(withVariations: nil)
         context?.setFont(copiedFont!)*/
        context?.setFillColor(scaleCor.cgColor)
        context?.setLineWidth(0)//采用的是FillStroke的方式，所以要把边线去掉，否则文字会很粗
        context?.setTextDrawingMode(.fillStroke)
        
        var string = String(format: "%ddB", db)
        var text = NSString(string: string)
        let textAttributes = [NSAttributedStringKey.foregroundColor: scaleCor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)] as [NSAttributedStringKey
            : NSObject]
        text.draw(at: CGPoint(x: m_rect.origin.x, y: m_borderRect.origin.y - 6.0), withAttributes: textAttributes)
        
        for i in 0 ..< 8 {
            db -= (m_maxdB / 4)
            string = String(format: "%ddB", db)
            text = NSString(string: string)
            if (db < 20)
            {
                if (db >= 10 && db < 20)
                {
                    drawPoint.x = m_rect.origin.x+2
                    drawPoint.y = CGFloat(Double(m_borderRect.origin.y) + Double(i+1)*pos - 6.0)
                    text.draw(at: drawPoint, withAttributes: textAttributes)
                }
                else if (db >= 0 && db < 10)
                {
                    drawPoint.x = m_rect.origin.x + 8
                    drawPoint.y = CGFloat(Double(m_borderRect.origin.y) + Double(i+1)*pos - 6.0)
                    text.draw(at: drawPoint, withAttributes: textAttributes)
                }
                else if (db > -10 && db < 0)
                {
                    drawPoint.x = m_rect.origin.x + 4
                    drawPoint.y = CGFloat(Double(m_borderRect.origin.y) + Double(i+1)*pos - 6.0)
                    text.draw(at: drawPoint, withAttributes: textAttributes)
                }
                else
                {
                    drawPoint.x = m_rect.origin.x + 0
                    drawPoint.y = CGFloat(Double(m_borderRect.origin.y) + Double(i+1)*pos - 6.0)
                    text.draw(at: drawPoint, withAttributes: textAttributes)
                }
            }
        }
        
        w = Float(Double(m_borderRect.width) / (log10(Double(m_highFreq))-log10(Double(m_lowFreq))))
        
        var i: Int = Int(m_lowFreq)
        
        
        repeat {
            f = Float(log10(Double(i))-log10(Double(m_lowFreq)))
            if (f >= 0)
            {
                //刻度文字
                if ((i == Int(round((pow(Double(10),Double(bitsOfNumber(value: i)))))) && i != Int(m_lowFreq)) || (f==0))
                {
                    if (i < 1000) {
                        string = String(format: "%dHz", i)
                    }
                    else {
                        string = String(format: "%dKHz", i/1000)
                    }
                    drawPoint.x = m_borderRect.origin.x + CGFloat(f * w) - 10
                    drawPoint.y = CGFloat(10.0 + Double(m_borderRect.origin.y+m_borderRect.height) - 6.0)+4
                    text = NSString(string: string)
                    text.draw(at: drawPoint, withAttributes: textAttributes)
                }
            }
            i += Int(round(pow(10.0, Double(bitsOfNumber(value: i)))))
        } while(Float(i) < m_highFreq)
        
        
        context?.restoreGState()
    }
    
    // 画频率曲线
    private func paintFreqCurve() {
        var sum: Double
        var s_x: Int = 0
        var s_y: Int = 0
        var e_x: Int
        var e_y: Int
        var leftpos: Double
        var k: Double
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.setLineWidth(2.0)
        context?.setStrokeColor(curveCor.cgColor)
        for n in 0 ..< FilterGraphView.NF {
            sum = Double(H[n])
            //8行,每行6个数值
            k = (sum * Double(m_borderRect.height) / Double(m_maxdB - m_mindB))
            guard !(k.isNaN || k.isInfinite) else {
                print("error: filter paintFreqCurve k isNan or isInfinite")
                continue
            }
            
            leftpos = freqToPos(freq: FilterGraphView.FreqTable[n]);
            if (leftpos > Double(m_borderRect.width)) {
                break
            }
            e_x = Int(leftpos + Double(m_borderRect.origin.x))
            e_y = Int(Double(m_borderRect.origin.y) + Double(m_borderRect.height) - Double(m_borderRect.height) / 2.0 - k)
            
            //限制区域,防止越界
            var f_e_x: CGFloat = CGFloat(e_x)
            var f_e_y: CGFloat = CGFloat(e_y)
            CLIP_RGN(x: &f_e_x, y: &f_e_y, rect: m_borderRect)
            e_x = Int(f_e_x)
            e_y = Int(f_e_y)
            
            if (n > 0) {
                context?.move(to: CGPoint(x: s_x, y: s_y))
                context?.addLine(to: CGPoint(x: e_x, y: e_y))
                context?.drawPath(using: .stroke)
            }
            s_x = e_x
            s_y = e_y
        }
        
        
        context?.restoreGState()
    }
    
    // 画可拖拽的点
    private func paintMovePoint() {
        var textOffset: Int
        var msg: String
        let context = UIGraphicsGetCurrentContext()
        var text: NSString
        
        //print("m_borderRect.orgin.x=\(m_borderRect.origin.x)")
        //print("m_borderRect.orgin.y=\(m_borderRect.origin.y)")
        for i in 0 ..< m_peqBand+2 {
            if (i == m_peqBand) {
                //高通
                m_moveRect[i].origin.x = m_borderRect.origin.x + CGFloat(freqToPos(freq: Double(hpf_freq))) - CGFloat(8)
                m_moveRect[i].origin.y = m_borderRect.origin.y + CGFloat(m_maxdB-0) / (CGFloat(m_maxdB - m_mindB)/m_borderRect.height) - CGFloat(8)
                msg = "H"
                textOffset = 4
                //print("---\(freqToPos(freq: Double(hpf_freq)))")
                //print("H: m_moveRect[\(i)].orgin.x=\(m_moveRect[i].origin.x)")
                //print("H: m_moveRect[\(i)].orgin.y=\(m_moveRect[i].origin.y)")
            }
            else if (i == m_peqBand+1) {
                //低通
                m_moveRect[i].origin.x = m_borderRect.origin.x + CGFloat(freqToPos(freq: Double(lpf_freq))) - CGFloat(8)
                m_moveRect[i].origin.y = m_borderRect.origin.y + CGFloat(m_maxdB-0) / (CGFloat(m_maxdB - m_mindB)/m_borderRect.height) - CGFloat(8)
                msg = "L"
                textOffset = 5
                //print("L: m_moveRect[\(i)].orgin.x=\(m_moveRect[i].origin.x)")
                //print("L: m_moveRect[\(i)].orgin.y=\(m_moveRect[i].origin.y)")
            }
            else {
                m_moveRect[i].origin.x = m_borderRect.origin.x + CGFloat(freqToPos(freq: Double(eq_freq[i]))) - CGFloat(8)
                m_moveRect[i].origin.y = m_borderRect.origin.y + CGFloat(Float(m_maxdB)-eq_gain[i]) / (CGFloat(m_maxdB - m_mindB)/m_borderRect.height) - CGFloat(8)
                msg = String(format: "%d", i + 1)
                if (msg.lengthOfBytes(using: .ascii) == 1) {
                    textOffset = 5
                } else {
                    textOffset = 2
                }
                //print("------\(eq_freq[i])---\(freqToPos(freq: Double(eq_freq[i])))")
                //print("Other: m_moveRect[\(i)].orgin.x=\(m_moveRect[i].origin.x)")
                //print("Other: m_moveRect[\(i)].orgin.y=\(m_moveRect[i].origin.y)")
            }
            //print("1:\(m_moveRect[i].width),\(m_moveRect[i].size.width)")
            m_moveRect[i].size.width = 16 //.setRight(m_moveRect[i].left()+16);
            m_moveRect[i].size.height = 16 //.setBottom(m_moveRect[i].top()+16);
            //print("2:\(m_moveRect[i].width),\(m_moveRect[i].size.width)")
            
            context?.saveGState()
            if bPressed[i] {
                context?.setStrokeColor(movePointHighlightedStrokeColor.cgColor)
            } else {
                context?.setStrokeColor(movePointFillColor.cgColor)
            }
            /*if (i >= m_peqBand)
             {
             context?.setFillColor(movePointFillColor.cgColor)
             context?.addEllipse(in: m_moveRect[i])
             context?.drawPath(using: .fillStroke)
             }
             else
             {*/
            context?.setFillColor(movePointFillColor.cgColor)
            context?.addEllipse(in: m_moveRect[i])
            context?.drawPath(using: .fillStroke)
            //}
            context?.restoreGState()
            
            context?.saveGState()
            //context?.setFillColor(UIColor.black.cgColor)
            context?.setLineWidth(0)//采用的是FillStroke的方式，所以要把边线去掉，否则文字会很粗
            context?.setTextDrawingMode(.fillStroke)
            text = NSString(string: msg)
            
            text.draw(at: CGPoint(x: m_moveRect[i].origin.x + CGFloat(textOffset), y: 0 + m_moveRect[i].origin.y), withAttributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
            context?.restoreGState()
        }
    }
    
    private func setFirstOrder(type: Int, fc: Float, a: inout [Double], b: inout [Double]) {
        var k: Double
        var wc: Double
        var b0: Double
        var b1: Double
        var a0: Double
        var a1: Double
        
        wc = Double(2) * Double(FilterGraphView.PI) * Double(fc)
        k = wc / tan(Double(fc) * Double(FilterGraphView.PI) / Double(FilterGraphView.Fs))
        
        if (type == 1)// 'HPF
        {
            b0 = k
            b1 = -k
            a0 = k + wc
            a1 = wc - k
            
            b[0] = b0 / a0
            b[1] = b1 / a0
            b[2] = 0
            a[0] = 1
            a[1] = a1 / a0
            a[2] = 0
        }
        else if (type == 2) //LPF
        {
            b0 = wc
            b1 = wc
            a0 = k + wc
            a1 = wc - k
            
            b[0] = b0 / a0
            b[1] = b1 / a0
            b[2] = 0
            a[0] = 1
            a[1] = a1 / a0
            a[2] = 0
        }
    }
    
    private func secondCoefgen(type: Int, f0: Float, Q: Float, dBgain: Float, aa: inout [Double], bb: inout [Double]) {
        let w0: Double = Double(2) * FilterGraphView.PI * Double(f0) / Double(FilterGraphView.Fs)
        let alpha: Double = sin(w0) / Double(2 * Q)
        let A: Double = pow(Double(10), (Double(dBgain) / Double(40)))
        var b0: Double
        var b1: Double
        var b2: Double
        var a0: Double
        var a1: Double
        var a2: Double
        
        switch (type) {
        case 0:
            b0 = 1 - alpha
            b1 = -2 * cos(w0)
            b2 = 1 + alpha
            a0 = 1 + alpha
            a1 = -2 * cos(w0)
            a2 = 1 - alpha
            break
        case 1:
            b0 = (1 + cos(w0)) / 2
            b1 = -(1 + cos(w0))
            b2 = (1 + cos(w0)) / 2
            a0 = 1 + alpha
            a1 = -2 * cos(w0)
            a2 = 1 - alpha
            break
        case 2:
            b0 = (1 - cos(w0)) / 2
            b1 = 1 - cos(w0)
            b2 = (1 - cos(w0)) / 2
            a0 = 1 + alpha
            a1 = -2 * cos(w0)
            a2 = 1 - alpha
            break
        case 3:
            b0 = 1 + alpha * A
            b1 = -2 * cos(w0)
            b2 = 1 - alpha * A
            a0 = 1 + alpha / A
            a1 = -2 * cos(w0)
            a2 = 1 - alpha / A
            break
        case 4:
            b0 = A * ((A + 1) - (A - 1) * cos(w0) + 2 * sqrt(A) * alpha)
            b1 = 2 * A * ((A - 1) - (A + 1) * cos(w0))
            b2 = A * ((A + 1) - (A - 1) * cos(w0) - 2 * sqrt(A) * alpha)
            a0 = (A + 1) + (A - 1) * cos(w0) + 2 * sqrt(A) * alpha
            a1 = -2 * ((A - 1) + (A + 1) * cos(w0))
            a2 = (A + 1) + (A - 1) * cos(w0) - 2 * sqrt(A) * alpha
            break
        case 5:
            b0 = A * ((A + 1) + (A - 1) * cos(w0) + 2 * sqrt(A) * alpha)
            b1 = -2 * A * ((A - 1) + (A + 1) * cos(w0))
            b2 = A * ((A + 1) + (A - 1) * cos(w0) - 2 * sqrt(A) * alpha)
            a0 = (A + 1) - (A - 1) * cos(w0) + 2 * sqrt(A) * alpha
            a1 = 2 * ((A - 1) - (A + 1) * cos(w0))
            a2 = (A + 1) - (A - 1) * cos(w0) - 2 * sqrt(A) * alpha
            break
        default:
            b0 = 0
            b1 = 0
            b2 = 0
            a0 = 0
            a1 = 0
            a2 = 0
            break
        }
        
        aa[0] = 1
        aa[1] = a1 / a0
        aa[2] = a2 / a0
        bb[0] = b0 / a0
        bb[1] = b1 / a0
        bb[2] = b2 / a0
    }
    
    private func freqz(a: inout [Double], b: inout [Double], h: inout [complex], n: Int) {
        var bsum: complex = complex(real: 0.0, imag: 0.0)
        var asum: complex = complex(real: 0.0, imag: 0.0)
        var z: complex = complex(real: 0.0, imag: 0.0)
        var k: Int
        var s: Double
        var sf: Double
        var sa: Double
        var sb: Double
        var temp: Double
        
        s = FilterGraphView.PI / Double(n)
        //只用计算用到的405个点幅值
        for f in 0 ..< FilterGraphView.NF {
            k = Int(FilterGraphView.FreqTable[f] * Double(10))
            
            sf = s * Double(k)
            bsum.real = b[0]
            bsum.imag = 0
            for i in 1 ..< FilterGraphView.lb {
                sb = sf * Double(i)
                z.real = cos(sb)
                z.imag = sin(sb)
                bsum.real += b[i] * z.real
                bsum.imag += b[i] * z.imag
            }
            
            asum.real = 1
            asum.imag = 0
            
            for i in 1 ..< FilterGraphView.la {
                sa = sf * Double(i)
                z.real = cos(sa)
                z.imag = -sin(sa)
                asum.real += a[i] * z.real
                asum.imag += a[i] * z.imag
            }
            
            temp = asum.real * asum.real + asum.imag * asum.imag;
            h[f].real = (bsum.real * asum.real + bsum.imag * asum.imag) / temp;
            h[f].imag = (bsum.imag * asum.real - bsum.real * asum.imag) / temp;
            if(f < 100)
            {
                //qDebug("%d--%f:%f:%f\n",f,temp,h[f].real,h[f].imag);
            }
        }
    }
    
    private func updateCurve() {
        H = Array<Float>(repeating: 0.0, count: FilterGraphView.NF)
        
        if (!hpf_byp)
        {
            calcHLPFCorrespondingValue(lpf: 0, type: UInt8(hpf_type.rawValue), slope: UInt8(hpf_slope.rawValue), freq: hpf_freq)
        }
        if (!lpf_byp)
        {
            calcHLPFCorrespondingValue(lpf: 1, type: UInt8(lpf_type.rawValue), slope: UInt8(lpf_slope.rawValue), freq: lpf_freq)
        }
        //calcPEQCorrespondingValue(0,20,-12,1)
        for i in 0 ..< m_peqBand {
            if (!eq_byp[i])
            {
                calcPEQCorrespondingValue(type: eq_type[i], freq: eq_freq[i], gain: eq_gain[i], Q: eq_Q[i])
            }
        }
        setNeedsDisplay()
    }
    
    private func calcHLPFCorrespondingValue(lpf: UInt8, type: UInt8, slope: UInt8, freq: Float) {
        var Q: Double
        var numSections: Int
        var hh: [complex] = Array<complex>(repeating: complex(real: 0.0, imag: 0.0), count: FilterGraphView.NF)
        
        //lpf = 0;//pCmd[1]  & 0xFF; 低通=1，高通=0
        //type =  0;//(pCmd[1] >> 8) & 0xFF; 对应协议里面的类型
        //slope = 1;//pCmd[1] >> 16; 对应协议里面的斜率
        
        //freq = 1000;
        
        numSections = FilterGraphView.numSectionsbuf[Int(slope)]
        
        for i in 0 ..< numSections/2 {
            Q = Double(FilterGraphView.Qbuf[Int(type*5 + slope-1)][i])
            secondCoefgen(type: Int(lpf)+1, f0: freq, Q: Float(Q), dBgain: 0, aa: &d_factor, bb: &n_factor);
            
            freqz(a: &d_factor, b: &n_factor, h: &hh, n: FilterGraphView.N); //婊ゆ尝鍣ㄩ鐜囧搷搴旀洸绾跨敓鎴
            for j in 0 ..< FilterGraphView.NF {
                H[j] += 20 * log10(mabs(sum: hh[j])); //绱姞
            }
        }
        
        if(numSections == 1 || numSections == 3)//highpass order 3
        {
            setFirstOrder(type: Int(lpf+1), fc: freq, a: &d_factor, b: &n_factor);
            
            freqz(a: &d_factor, b: &n_factor, h: &hh, n: FilterGraphView.N); //滤波器频率响应曲线生成
            for j in 0 ..< FilterGraphView.NF {
                H[j] += 20 * log10(mabs(sum: hh[j])); //累加
            }
        }
    }
    
    private func calcPEQCorrespondingValue(type: UInt8, freq: Float, gain: Float, Q: Float) {
        var hh: [complex] = Array<complex>(repeating: complex(real: 0.0, imag: 0.0), count: FilterGraphView.NF)
        
        secondCoefgen(type: Int(type + 3), f0: freq, Q: Q, dBgain: gain, aa: &d_factor, bb: &n_factor);
        
        freqz(a: &d_factor, b: &n_factor, h: &hh, n: FilterGraphView.N);
        for j in 0 ..< FilterGraphView.NF {
            H[j] += 20 * log10(mabs(sum: hh[j]));
            //qDebug("%d-%f:%f:%f",j,H[j],hh[j].real,hh[j].imag);
        }
    }
    
    private func mabs(sum: complex) -> Float {
        let tmp = Float(sum.real * sum.real + sum.imag * sum.imag)
        return sqrt(tmp)
    }
    
    private func freqToPos(freq: Double) -> Double {
        let w: Double = (Double(m_borderRect.width) / Double(log10(m_highFreq)-log10(m_lowFreq)))
        let f: Double = Double(log10(freq)) - Double(log10(m_lowFreq))
        
        return (f*w)
    }
    
    private func posToFreq(pos: Double) -> Double {
        //根据x坐标位置值,计算出对应的频率值
        let w: Double = (Double)(Double(m_borderRect.width) / (log10((Double)(m_highFreq)) - log10((Double)(m_lowFreq))))
        let f: Double = pow(10, (pos/w) + log10((Double)(m_lowFreq)))
        
        return f
    }
    
    private func bitsOfNumber(value: Int) -> Int {
        var val = value
        var result: Int = 0
        
        if (val < 10) {
            return 0
        }
        
        repeat {
            val = val / 10
            result += 1
        } while(val >= 10)
        return result
    }
    
    // 外部接口函数：设置高通滤波器
    func setHPFilter(byp: Bool, type: UInt8, slope: UInt8, freq: Float) {
        hpf_byp = byp
        hpf_type = hlpf_type(rawValue: Int(type))!
        hpf_slope = hlpf_slope(rawValue: Int(slope))!
        hpf_freq = freq
        updateCurve()
    }
   @objc func setHPFilter(byp: Bool) {
        hpf_byp = byp
        updateCurve()
    }
   @objc func setHPFilter(type: UInt8) {
        hpf_type = hlpf_type(rawValue: Int(type))!
        updateCurve()
    }
   @objc func setHPFilter(slope: UInt8) {
        hpf_slope = hlpf_slope(rawValue: Int(slope))!
        updateCurve()
    }
   @objc func setHPFilter(freq: Float) {
        hpf_freq = freq
        updateCurve()
    }
    
    // 外部接口函数：设置低通滤波器
    func setLPFilter(byp: Bool, type: UInt8, slope: UInt8, freq: Float) {
        lpf_byp = byp
        lpf_type = hlpf_type(rawValue: Int(type))!
        lpf_slope = hlpf_slope(rawValue: Int(slope))!
        lpf_freq = freq
        updateCurve()
    }
   @objc func setLPFilter(byp: Bool) {
        lpf_byp = byp
        updateCurve()
    }
   @objc func setLPFilter(type: UInt8) {
        lpf_type = hlpf_type(rawValue: Int(type))!
        updateCurve()
    }
   @objc func setLPFilter(slope: UInt8) {
        lpf_slope = hlpf_slope(rawValue: Int(slope))!
        updateCurve()
    }
   @objc func setLPFilter(freq: Float) {
        lpf_freq = freq
        updateCurve()
    }
    
    // 外部接口函数：设置PEQ
    func setPEQ(band: UInt8, byp: Bool, type: UInt8, freq: Float, gain: Float, Q: Float) {
        eq_byp[Int(band)] = byp
        eq_type[Int(band)] = type
        eq_freq[Int(band)] = freq
        eq_gain[Int(band)] = gain
        if type == filter_type.type_PEQ.rawValue {
            eq_Q[Int(band)] = Q
        } else {
            eq_Q[Int(band)] = 0.71
        }
        updateCurve()
    }
    @objc func setPEQ(band: UInt8, byp: Bool) {
        eq_byp[Int(band)] = byp
        updateCurve()
    }
    @objc func setPEQ(band: UInt8, type: UInt8, Q: Float) {
        eq_type[Int(band)] = type
        if type == filter_type.type_PEQ.rawValue {
            eq_Q[Int(band)] = Q
        } else {
            eq_Q[Int(band)] = 0.71  //low/high shelf, the Q is 0.71
        }
        updateCurve()
    }
   @objc func setPEQ(band: UInt8, freq: Float) {
        eq_freq[Int(band)] = freq
        updateCurve()
    }
    @objc func setPEQ(band: UInt8, gain: Float) {
        eq_gain[Int(band)] = gain
        updateCurve()
    }
    @objc func setPEQ(band: UInt8, Q: Float) {
        if eq_type[Int(band)] == filter_type.type_PEQ.rawValue {
            eq_Q[Int(band)] = Q
        } else {
            eq_Q[Int(band)] = 0.71
        }
        updateCurve()
    }
    
    // 外部接口函数：设置增益范围
    func setGainRange(max: Int, min: Int) {
        m_maxdB = max
        m_mindB = min
        setNeedsDisplay()
    }
    
    // 外部接口函数：设置PEQ段数
    func setPeqBand(band: Int) {
        //if band > FilterGraphView.MAX_EQ_BAND {
        //band = FilterGraphView.MAX_EQ_BAND
        //}
        m_peqBand = band > FilterGraphView.MAX_EQ_BAND ? FilterGraphView.MAX_EQ_BAND : band
        updateCurve()
    }
    
    func getPeqBand() -> Int {
        return m_peqBand
    }
}


