//
//  EnergyTipsView.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import SwiftUI

struct EnergyTipsView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var selectedCategory: EnergyTip.TipCategory = .general
    @State private var searchText = ""
    
    private let energyTips: [EnergyTip] = [
        EnergyTip(
            titleAR: "اضبط المكيف على 24 درجة مئوية",
            titleEN: "Set AC to 24°C",
            descriptionAR: "كل درجة أقل من 24 تزيد استهلاك الكهرباء بنسبة 6-8%. درجة 24 مئوية هي الدرجة المثلى للراحة والكفاءة",
            descriptionEN: "Each degree below 24°C increases electricity consumption by 6-8%. 24°C is optimal for comfort and efficiency",
            category: .cooling,
            estimatedSavings: "15-20%",
            difficulty: .easy,
            icon: "thermometer"
        ),
        EnergyTip(
            titleAR: "استخدم المراوح مع المكيف",
            titleEN: "Use fans with AC",
            descriptionAR: "المراوح تساعد على توزيع الهواء البارد بشكل أفضل، مما يسمح برفع درجة حرارة المكيف درجتين مع الحفاظ على الراحة",
            descriptionEN: "Fans help distribute cool air better, allowing you to raise AC temperature by 2°C while maintaining comfort",
            category: .cooling,
            estimatedSavings: "10-15%",
            difficulty: .easy,
            icon: "wind"
        ),
        EnergyTip(
            titleAR: "نظف فلاتر المكيف شهرياً",
            titleEN: "Clean AC filters monthly",
            descriptionAR: "الفلاتر المتسخة تجعل المكيف يعمل بجهد أكبر. التنظيف الشهري يحسن الكفاءة ويوفر الطاقة",
            descriptionEN: "Dirty filters make AC work harder. Monthly cleaning improves efficiency and saves energy",
            category: .cooling,
            estimatedSavings: "5-10%",
            difficulty: .easy,
            icon: "air.purifier"
        ),
        EnergyTip(
            titleAR: "استخدم LED بدلاً من المصابيح العادية",
            titleEN: "Use LED instead of regular bulbs",
            descriptionAR: "مصابيح LED تستهلك طاقة أقل بنسبة 80% وتدوم أطول 25 مرة من المصابيح التقليدية",
            descriptionEN: "LED bulbs use 80% less energy and last 25 times longer than traditional bulbs",
            category: .lighting,
            estimatedSavings: "75-80%",
            difficulty: .easy,
            icon: "lightbulb"
        ),
        EnergyTip(
            titleAR: "افصل الأجهزة عند عدم الاستخدام",
            titleEN: "Unplug devices when not in use",
            descriptionAR: "الأجهزة في وضع الاستعداد تستهلك طاقة. فصلها كلياً يوفر 5-10% من فاتورة الكهرباء",
            descriptionEN: "Devices on standby consume power. Unplugging saves 5-10% on electricity bills",
            category: .appliances,
            estimatedSavings: "5-10%",
            difficulty: .easy,
            icon: "powerplug"
        ),
        EnergyTip(
            titleAR: "استخدم الستائر العازلة",
            titleEN: "Use insulating curtains",
            descriptionAR: "الستائر العازلة تمنع دخول الحرارة نهاراً وتحافظ على برودة المنزل، مما يقلل الحاجة للمكيف",
            descriptionEN: "Insulating curtains block heat during day and keep home cool, reducing AC needs",
            category: .cooling,
            estimatedSavings: "10-15%",
            difficulty: .medium,
            icon: "curtains.closed"
        )
    ]
    
    var filteredTips: [EnergyTip] {
        var tips = energyTips
        
        if selectedCategory != .general {
            tips = tips.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            tips = tips.filter { tip in
                let title = localizationManager.isArabic ? tip.titleAR : tip.titleEN
                let description = localizationManager.isArabic ? tip.descriptionAR : tip.descriptionEN
                return title.localizedCaseInsensitiveContains(searchText) ||
                       description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return tips
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(EnergyTip.TipCategory.allCases, id: \.self) { category in
                            CategoryChip(
                                category: category,
                                isSelected: selectedCategory == category,
                                action: { selectedCategory = category }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Tips List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredTips) { tip in
                            EnergyTipCard(tip: tip)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(localizationManager.localizedString("energy_tips"))
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search tips...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.vertical, 8)
    }
}

struct CategoryChip: View {
    let category: EnergyTip.TipCategory
    let isSelected: Bool
    let action: () -> Void
    
    @EnvironmentObject var localizationManager: LocalizationManager
    
    private var categoryName: String {
        switch category {
        case .general: return localizationManager.isArabic ? "عام" : "General"
        case .cooling: return localizationManager.isArabic ? "التبريد" : "Cooling"
        case .heating: return localizationManager.isArabic ? "التدفئة" : "Heating"
        case .lighting: return localizationManager.isArabic ? "الإضاءة" : "Lighting"
        case .appliances: return localizationManager.isArabic ? "الأجهزة" : "Appliances"
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(categoryName)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.green : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

struct EnergyTipCard: View {
    let tip: EnergyTip
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: tip.icon)
                    .font(.title2)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(localizationManager.isArabic ? tip.titleAR : tip.titleEN)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        DifficultyBadge(difficulty: tip.difficulty)
                        Spacer()
                        SavingsBadge(savings: tip.estimatedSavings)
                    }
                }
                
                Spacer()
            }
            
            Text(localizationManager.isArabic ? tip.descriptionAR : tip.descriptionEN)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct DifficultyBadge: View {
    let difficulty: EnergyTip.Difficulty
    
    var color: Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
    
    var body: some View {
        Text(difficulty.rawValue.capitalized)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}

struct SavingsBadge: View {
    let savings: String
    
    var body: some View {
        Text("💰 \(savings)")
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.green.opacity(0.2))
            .foregroundColor(.green)
            .cornerRadius(8)
    }
}
