//
//  LTAboutViewController.swift
//  coolPer
//
//  **********************************************
//  *     _    _        _ˍ_ˍ_        _    _      *
//  *    | |  | |      |__   |      \ \  / /     *
//  *    | |__| |        /  /        \ \/ /      *
//  *    |  __  |       /  /          \  /       *
//  *    | |  | |      /  /__       __/ /        *
//  *    |_|  |_|      |_ˍ_ˍ_|     |_ˍ_/         *
//  *                                            *
//  **********************************************
//
//  Created by LonTe on 2019/10/14.
//  Copyright © 2019 LangTe. All rights reserved.
//


import UIKit

class LTAboutViewController: LTViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "关于"
        // Do any additional setup after loading the view.
        
        let scroll = UIScrollView()
        scroll.backgroundColor = .white
        view.addSubview(scroll)
        
        scroll.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let contentView = UIView()
        scroll.addSubview(contentView)
        
        let icon = UIImageView(image: #imageLiteral(resourceName: "icon_logo"))
        icon.contentMode = .scaleAspectFit
        contentView.addSubview(icon)
        
        icon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        let content = UILabel()
        content.numberOfLines = 0
        content.text = "\t深圳朗特伟业科技有限公司/深圳朗特基业科技有限公司，公司成立于2011年9月，专业从事手机方案设计、手机整机业务、移动模块、手机增值业务。现公司产品有： AI智能音箱、AI智能机器人、 AI智能手机、三防手机、2G/3G手机、手表手机PCBA、对讲机手机PCBA、儿童手机与GPS定位产品等，其中三防手机行业内排名第一！公司自有服务品，在手机系统有一系列的APP业务，在手机主板研产销各环节均有丰富的实战经验。凭借着杰出的研发队伍以及雄厚的研发和创新技术，为客户提供了最优秀的解决方案，使客户在竞争中获得持续稳定的收益。\n\n联系我们：\n\t电话: 180 2530 4158\n\t手机: 180 2530 4158\n\t邮箱: weweyouni@163.com\n深圳市南山区粤海街道科技园北区清华信息港综合楼709室"
        contentView.addSubview(content)
        
        content.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(KEYSCREEN_W)
            $0.bottom.equalTo(content).offset(50)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

