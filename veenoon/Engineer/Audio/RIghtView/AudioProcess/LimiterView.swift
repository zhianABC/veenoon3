//
//  LimiterView.swift
//  Mixer
//
//  Created by y on 17/5/4.
//  Copyright © 2017年 y. All rights reserved.
//

import UIKit

@IBDesignable
class LimiterView: UIView {
    static let MAX_LIMITER_BUFFER_LEN = 256
    static let DTEXT_YOFFSET = -2   //10
    struct st_limiter_param {
        var bypass: Bool
        var thresh: Float
        var ratio: Float
        var attack: Float
        var rels: Float
    }
    private var m_rectCtrl: CGRect!
    private var m_ValidRect: CGRect!
    private var m_Buffer: [Double]!
    private var m_BufferLen: Int!
    private var m_Ratio: Double!
    private var m_LimitLevel: Double!
    private var m_HL: Double!
    private var m_LL: Double!
    private var m_CornerPos: Int!
    private var bBypass: Bool!
    
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
        paintBorder()
    }
    
    // 额外的初始化
    private func additionnalInit() {
        m_Buffer = [Double](repeating:0.0, count: LimiterView.MAX_LIMITER_BUFFER_LEN)
        bBypass = false
        m_Ratio = 2.0
        m_HL = 15
        m_LL = -100
        m_CornerPos = 0
        m_rectCtrl = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        m_ValidRect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        m_LimitLevel=m_LL+(m_HL-m_LL)/2
        m_BufferLen = LimiterView.MAX_LIMITER_BUFFER_LEN
        
        GeneralLimitWave()
    }
    
    private func paintBorder() {
        let context = UIGraphicsGetCurrentContext()
        var w: Int
        var h: Int
        var j: Int
        var db: Int
        var leftpos: Int = 0
        var k: Int
        var point_xpos: Int = 0
        var point_ypos: Int = 0
        var limiter_val: Double
        var xreso: Double
        var f_step: Double
        var cor_x = 0
        var cor_y = 0
        var pt = [CGPoint](repeating: CGPoint(x: 0.0, y: 0.0), count: 4)
        var msg: String
        let bkCor = UIColor.clear;
        var text: NSString
        
        f_step = fabs(m_HL-m_LL) / 5
        m_rectCtrl = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        context?.saveGState()
        
        // 画黑色背景
        context?.setFillColor(bkCor.cgColor)
        context?.addRect(m_rectCtrl)
        context?.drawPath(using: .fill)
        
        m_ValidRect = CGRect(x: m_rectCtrl.origin.x+30, y: m_rectCtrl.origin.y+10, width: m_rectCtrl.origin.x+m_rectCtrl.width-10-30, height: m_rectCtrl.origin.y+m_rectCtrl.height-30-10)
        w = Int(Double(m_ValidRect.width) / 5.0)
        h = Int(Double(m_ValidRect.height) / 5.0)
        
        // 画有效矩形框区域不填充
        
        let yellowC = UIColor(red: 255/255.0, green: 180/255.0, blue: 0/255.0, alpha: 1.0);
        
        context?.setStrokeColor(yellowC.cgColor)
        context?.setLineWidth(1)
        context?.addRect(m_ValidRect)
        context?.drawPath(using: .stroke)
        
        xreso = Double(m_ValidRect.width) / Double(m_BufferLen)
        
        j = 0
        for n in 0 ..< m_BufferLen {
            limiter_val = m_Buffer[n]
            k = Int(limiter_val * Double(m_ValidRect.height) / Double(LimiterView.MAX_LIMITER_BUFFER_LEN))
            leftpos = Int(Double(j) * xreso)
            point_xpos = Int(Double(leftpos) + Double(m_ValidRect.origin.x))
            point_ypos = Int(Double(m_ValidRect.origin.y) + Double(m_ValidRect.height) - Double(k))
            
            if (m_CornerPos>0 && m_CornerPos==n)
            {
                cor_x=point_xpos
                cor_y=point_ypos
            }
            j += 1
        }
        
        if (cor_x==0 || cor_y==0)
        {
            cor_x = Int(m_ValidRect.origin.x)
            cor_y = Int(m_ValidRect.origin.y + m_ValidRect.height)
        }
        
        pt[0].x = m_ValidRect.origin.x
        pt[0].y = m_ValidRect.origin.y + m_ValidRect.height
        pt[1].x = CGFloat(cor_x)
        pt[1].y = CGFloat(cor_y)
        pt[2].x = CGFloat(point_xpos)
        pt[2].y = CGFloat(point_ypos)
        pt[3].x = m_ValidRect.origin.x + m_ValidRect.width
        pt[3].y = m_ValidRect.origin.y + m_ValidRect.height
        
        // 画四边形，描边并填充
        //context?.setStrokeColor(UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0).cgColor)
        context?.setStrokeColor(yellowC.cgColor)
        context?.setFillColor(UIColor(red: 1/255.0, green: 138/255.0, blue: 182/255.0, alpha: 0.3).cgColor)
        context?.move(to: pt[0])
        context?.addLine(to: pt[1])
        context?.addLine(to: pt[2])
        context?.addLine(to: pt[3])
        context?.drawPath(using: .fillStroke)
        
        // 绘制纵坐标文字：15
        db = Int(m_HL)
        msg = String(format: "%d", db)
        context?.setLineWidth(0)//采用的是FillStroke的方式，所以要把边线去掉，否则文字会很粗
        context?.setTextDrawingMode(.fillStroke)
        text = NSString(string: msg)
        text.draw(at: CGPoint(x: m_rectCtrl.origin.x + 2, y: CGFloat(LimiterView.DTEXT_YOFFSET)+m_ValidRect.origin.y), withAttributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1.0), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        // 绘制纵坐标标线及文字：-8,-31,-54,-77,-100
        for i in 0 ..< 5 {
            if i < 4 {
                context?.setStrokeColor(yellowC.cgColor)
                context?.setLineWidth(1)
                context?.move(to: CGPoint(x: Double(m_ValidRect.origin.x), y: Double(m_ValidRect.origin.y)+Double((i+1)*h)))
                context?.addLine(to: CGPoint(x: m_ValidRect.origin.x+m_ValidRect.width, y: m_ValidRect.origin.y+CGFloat((i+1)*h)))
                context?.drawPath(using: .stroke)
            }
            
            db -= Int(f_step)
            msg = String(format: "%d", db)
            
            context?.setLineWidth(0)//采用的是FillStroke的方式，所以要把边线去掉，否则文字会很粗
            context?.setTextDrawingMode(.fillStroke)
            text = NSString(string: msg)
            
            text.draw(at: CGPoint(x: m_rectCtrl.origin.x + 2, y: CGFloat(LimiterView.DTEXT_YOFFSET)+m_ValidRect.origin.y+CGFloat((i+1)*h-5)), withAttributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1.0), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        }
        
        // 绘制横坐标标线及文字：-77,-54,-31,-8,15
        db = Int(m_LL)
        for i in 0 ..< 5 {
            if i < 4 {
                context?.setStrokeColor(yellowC.cgColor)
                context?.setLineWidth(1)
                context?.move(to: CGPoint(x: Double(m_ValidRect.origin.x)+Double((i+1)*w), y: Double(m_ValidRect.origin.y)))
                context?.addLine(to: CGPoint(x: m_ValidRect.origin.x+CGFloat((i+1)*w), y: m_ValidRect.origin.y+m_ValidRect.height))
                context?.drawPath(using: .stroke)
            }
            
            db += Int(f_step)
            msg = String(format: "%d", db)
            
            context?.setLineWidth(0)//采用的是FillStroke的方式，所以要把边线去掉，否则文字会很粗
            context?.setTextDrawingMode(.fillStroke)
            text = NSString(string: msg)
            text.draw(at: CGPoint(x: m_rectCtrl.origin.x + CGFloat((i+1)*w+18), y: CGFloat(LimiterView.DTEXT_YOFFSET)+m_ValidRect.origin.y+m_ValidRect.height+CGFloat(3)), withAttributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1.0), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        }
        
        // 画线
        context?.setStrokeColor(yellowC.cgColor)
        context?.setLineWidth(1)
        context?.move(to: CGPoint(x: m_ValidRect.origin.x, y: m_ValidRect.origin.y+m_ValidRect.height))
        context?.addLine(to: CGPoint(x: m_ValidRect.origin.x+m_ValidRect.width, y: m_ValidRect.origin.y))
        context?.drawPath(using: .stroke)
        
        context?.restoreGState()
    }
    
    private func GeneralLimitWave() {
        var corner: Int = -1
        var m_l: Double
        var m_r: Double
        
        m_r = (m_HL - m_LL) / Double(m_BufferLen);
        for i in 0 ..< LimiterView.MAX_LIMITER_BUFFER_LEN {
            m_l = (m_LimitLevel - m_LL) / m_r
            if (Double(i)>=m_l && bBypass==false)
            {
                if (corner == -1) {
                    corner = i
                }
                
                if(m_Ratio > 19.0) {
                    m_Buffer[i] = m_l
                }
                else
                {
                    m_Buffer[i] = m_l + (1.0/m_Ratio) * (Double(i)-m_l)
                }
            }
            else
            {
                m_Buffer[i] = Double(i)
            }
        }
        
        
        if (corner != -1) {
            m_CornerPos = corner
        }
    }
    
    // 外部接口函数：设置限制器参数
    func setLimiterParam(pLimitParam: st_limiter_param) {
        m_Ratio = Double(pLimitParam.ratio)
        m_LimitLevel = Double(pLimitParam.thresh)
        bBypass = pLimitParam.bypass
        GeneralLimitWave()
        setNeedsDisplay()
    }
    
    // 外部接口函数：设置bypass
    func setBypass(b: Bool) {
        bBypass = b
        GeneralLimitWave()
        setNeedsDisplay()
    }
    
    // 外部接口函数：设置斜率
   @objc func setRatio(r: Double) {
        m_Ratio = r
        GeneralLimitWave()
        setNeedsDisplay()
    }
    
    // 外部接口函数：设置阈值
   @objc func setThresHold(r: Double) {
        m_LimitLevel = r
        GeneralLimitWave()
        setNeedsDisplay()
    }
    
   @objc func setMaxThreshold(threshold: Double) {
        m_HL = threshold
        setNeedsDisplay()
    }
    
   @objc func setMinThreshold(threshold: Double) {
        m_LL = threshold
        setNeedsDisplay()
    }
}


