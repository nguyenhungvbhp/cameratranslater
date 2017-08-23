//
//  language.swift
//  iSub
//
//  Created by CryRose on 6/12/17.
//  Copyright © 2017 tansociu. All rights reserved.
//

import Foundation

public class LangConstants {
    /*
    static let nameDownload =
        [ "Afrikaans",      "Azerbaijani",          "Belarusian",             "Bengali",   "Bulgarian",   "Catalan-Valencian",
          "Czech",          "Chinese - Simplified", "Chinese - Traditional",  "Cherokee",  "Danish",      "German",
          "Greek - Modern", "English",              "French",                 "Hindi",     "Indonesian",  "Italian",
          "Japanese",       "Korean",               "Portuguese",             "Russian",   "Thai",        "Vietnamese",
          "Arabic"
    ]

    
    static var arrDownload:[Bool] =
    [
        false, false, false, false, false, false,
        false, false, false, false, false, false,
        false, true,  false, false, false, false,
        false, false, false, false, false, false,
        false
    ]
    
    static var arrCodeLanguge: [String] =
    [
     "afr",     "aze",     "bel",      "ben",   "bul",  "cat",
     "ces",     "chi_sim", "chi_tra",  "chr",   "dan",  "deu",
     "ell",     "eng",     "fra",      "hin",   "ind",  "ita",
     "jpn",     "kor",     "por",      "rus",   "tha",  "vie",
     "ara"
    ]
    
    //lưu url để tải các file
    static let arrURL:[URL] = [
       
       URL.init(string: "https://www.dropbox.com/sh/p4gudlqi0yxie47/AADbsWDXWAmCGMzLstrqsLt_a?dl=1")!,//1
        
       URL.init(string: "https://www.dropbox.com/sh/9szqspbu2mdo35j/AAAT4ccW1hBDxToL-aiWuviEa?dl=1")!,//2
        
       URL.init(string: "https://www.dropbox.com/sh/jnp5xpv139q0pef/AAA_G2tn_gq1acadNq7V0LfSa?dl=1")!,//3
        
       URL.init(string: "https://www.dropbox.com/sh/xhnvsnm5lswnly8/AABqhSQcsjA45rsG61odPq6Na?dl=1")!,//4
        
       URL.init(string: "https://www.dropbox.com/sh/418hvdxzusdlfh5/AACKeScKkYD0hfJBsTV8Mn-Za?dl=1")!,//5
        
       URL.init(string: "https://www.dropbox.com/sh/vs1db8p1aj5xjwz/AACsVElqZ0gBX_opy_wnJipJa?dl=1")!,//6
        
       URL.init(string: "https://www.dropbox.com/sh/k696cxposf1t4yt/AAAGur1ytuDwndkOmLi1PvDMa?dl=1")!,//7
        
       URL.init(string: "https://www.dropbox.com/sh/98zusif2religi2/AADWpXGJ9-oizM7jQQ3lFaAla?dl=1")!,//8
        
       URL.init(string: "https://www.dropbox.com/sh/ihq6wipzpttr2qa/AADlfvxH4sivTaGEcY2PbCZXa?dl=1")!,//9
        
       URL.init(string: "https://www.dropbox.com/sh/ce7n3sgqq5y7aov/AAAbDGx69sK0HdLn9UYa2_v-a?dl=1")!,//10
        
       URL.init(string: "https://www.dropbox.com/sh/p2bwa7zdlfmqbpf/AAAUTBxqriOeuXpml_OyHyxCa?dl=1")!,//11
        
       URL.init(string: "https://www.dropbox.com/sh/cz8yzq7y7ho748f/AADLpRWTFW7sRRAW7xUq58vSa?dl=1")!,//12
        
       URL.init(string: "https://www.dropbox.com/sh/pxris1wguhkluj7/AADNAZtbtyxsBD-Syrtk3hzHa?dl=1")!,//13
        
       URL.init(string: "https://www.dropbox.com/sh/vr6gq6r8tsro9km/AABMcnDZr2qvoCaLmL-mLX-Ta?dl=1")!,//14
        
       URL.init(string: "https://www.dropbox.com/sh/idkqb5u1zxldg96/AAAhyMH1wZskMxG-pfvm8UzAa?dl=1")!,//15
        
       URL.init(string: "https://www.dropbox.com/sh/03g7za87l39y3wv/AACVtZx7VQ0pOe6jYz73wZ-na?dl=1")!,//16
        
       URL.init(string: "https://www.dropbox.com/sh/erly6o4m66yb6s7/AADwote9B4Mhj6bpvVJNiEC6a?dl=1")!,//17
        
       URL.init(string: "https://www.dropbox.com/sh/dh6bt29rr2uruad/AAAMgPNzUPY4VfwtjeV-KaFla?dl=1")!,//18
        
       URL.init(string: "https://www.dropbox.com/sh/k6s6lt7xyaysj19/AAB6IFDlO5e9mRZ2zYrPHhqNa?dl=1")!, //19
        
       URL.init(string: "https://www.dropbox.com/sh/9ga0ow5c6e9p56y/AADnwpIQ_EOINxIRJqhn7NOUa?dl=1")!,//20
        
       URL.init(string: "https://www.dropbox.com/sh/upqyokzbx87uztq/AAA0E3yd7vPhW6TbGXLwoMIqa?dl=1")!,//21
        
       URL.init(string: "https://www.dropbox.com/sh/wzt344hb9ks1cqw/AAAHtIdbQ6lvUb-Vl5CkDEUra?dl=1")!,//22
        
       URL.init(string: "https://www.dropbox.com/sh/pntcrqdxr62giy4/AACVr11moXxfq_7DyFC9uSKQa?dl=1")!,//23
        
       URL.init(string: "https://www.dropbox.com/sh/2j0gkppxm0jmkgj/AAANWOhP6Ii7HnvqwNJz7qs2a?dl=1")!,//24
        
       URL.init(string: "https://www.dropbox.com/sh/jpk28ln6laq2nkk/AAC1LZTBzROsDSEhd2DVcuPXa?dl=1")! // 25
    ]

    */
    static let arrLang =
        [   "Afrikaans",     "Albanian",     "Amharic",       "Arabic",     "Armenian",      "Azerbaijani",
            "Basque",        "Belarusian",   "Bengali",       "Bosnian",    "Bulgarian",     "Burmese",
            "Catalan",       "Cebuano",      "Chinese",       "Corsican",   "Croatian",      "Czech",
            "Danish",        "Dutch",        "English",       "Esperanto",  "Estonian",      "Finnish",
            "French",        "Galician",     "Georgian",      "German",     "Greek",         "Gujarati",
            "Haitian",       "Hausa",        "Hawaiian",      "Hebrew",     "Hindi",          "Hmong",
            "Hungarian",     "Icelandic",    "Igbo",          "Indonesian", "Irish",          "Italian",
            "Japanese",      "Javanese",     "Kannada",       "Kazakh",     "Khmer",          "Korean",
            "Kurdish",       "Kyrgyz",       "Lao",           "Latin",      "Latvian",        "Lithuanian",
            "Luxembourgish", "Macedonian",   "Malagasy",      "Malay",      "Malayalam",      "Maltese",
            "Maori",         "Marathi",      "Mongolian",     "Nepali",     "Norwegian",       "Nyanja",
            "Pashto",        "Persian",      "Polish",        "Portuguese", "Punjabi",         "Romanian",
            "Russian",       "Samoan",       "Scottish Gaelic","Serbian",    "Shona",           "Sindhi",
            "Sinhala",       "Slovak",       "Slovenian",      "Somali",     "Southern Sotho",  "Spanish",
            "Sundanese",     "Swahili",      "Swedish",        "Tajik",      "Tamil",           "Telugu",
            "Thai",          "Turkish",      "Ukrainian",      "Urdu",       "Uzbek",           "Vietnamese",
            "Welsh",         "Xhosa",        "Yiddish",        "Yoruba",     "Zulu"
    ]
    
    static let arrCode = ["af", "sq",
    "am", "ar", "hy",
    "az", "eu", "be",
    "bn", "bs", "bg",
    "my", "ca", "ceb",
    "zh-CN", "co", "hr", "cs",
    "da", "nl", "en",
    "eo", "et", "fi",
    "fr", "gl", "ka",
    "de", "el", "gu",
    "ht", "ha", "haw",
    "iw", "hi", "hmn",
    "hu", "is", "ig",
    "id", "ga", "it",
    "ja", "jw", "kn",
    "kk", "km", "ko",
    "ku", "ky", "lo",
    "la", "lv", "lt",
    "lb", "mk", "mg",
    "ms", "ml", "mt",
    "mi", "mr", "mn",
    "ne", "no", "ny",
    "ps", "fa", "pl",
    "pt", "pa", "ro",
    "ru", "sm", "gd",
    "sr", "sn", "sd",
    "si", "sk", "sl",
    "so", "st", "es",
    "su", "sw", "sv",
    "tg", "ta",
    "te", "th", "tr",
    "uk", "ur", "uz",
    "vi", "cy", "xh",
    "yi", "yo", "zu"
    ]
    
    static let arrFlag = ["flag_south_africa", "flag_albania",
    "flag_amharic", "flag_saudi_arabia", "flag_armenia",
    "flag_azerbaijan", "flag_basque", "flag_belarus",
    "flag_bangladesh", "flag_bosnia_herzegovina", "flag_bulgarian",
    "flag_burmese", "flag_catalan", "flag_philippines",
    "flag_china", "flag_corsican", "flag_croatia", "flag_czech",
    "flag_dania", "flag_netherlands", "flag_english",
    "flag_esperanto", "flag_estonia", "flag_finland",
    "flag_france", "flag_galician", "flag_georgia",
    "flag_germany", "flag_greek", "flag_india",
    "flag_haiti", "flag_nigeria", "flag_hawaiian",
    "flag_israel", "flag_india", "flag_china",
    "flag_hungary", "flag_iceland", "flag_nigeria",
    "flag_indonesia","flag_ireland", "flag_italy",
    "flag_japan", "flag_indonesia", "flag_india",
    "flag_kazakh", "flag_cambodia", "flag_korea",
    "flag_kurdish", "flag_kyrgyz", "flag_laos",
    "flag_latin", "flag_latvia", "flag_lithuania",
    "flag_luxembourgish", "flag_macedonia", "flag_malagasy",
    "flag_malaysia", "flag_malayalam", "flag_maltese",
    "flag_maori", "flag_india", "flag_mongolia",
    "flag_nepali","flag_norway", "flag_nyanja",
    "flag_pashto", "flag_iran", "flag_polish",
    "flag_portugal", "flag_india", "flag_romania",
    "flag_russia", "flag_samoan", "flag_scottish_gaelic",
    "flag_serbia", "flag_shona", "flag_sindhi",
    "flag_sri_lanka", "flag_slovakia", "flag_slovenia",
    "flag_somali", "flag_southern_sotho", "flag_spain",
    "flag_sundanese", "flag_south_africa", "flag_sweden",
    "flag_tajik", "flag_sri_lanka",
    "flag_india", "flag_thailand", "flag_turkey",
    "flag_ukraine", "flag_pakistan", "flag_uzbek",
    "flag_vietnam", "flag_welsh", "flag_xhosa",
    "flag_yiddish", "flag_nigeria", "flag_south_africa"
    ]
}
