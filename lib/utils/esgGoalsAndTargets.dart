import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<dynamic> getEsgGoalsCard() {
  return [
    {
      "name": "Environmental",
      "subtitle": "6 Subcategories",
      "cardColor": Colors.green
    },
    {
      "name": "Social",
      "subtitle": "6 Subcategories",
      "cardColor": Colors.blue
    },
    {
      "name": "Governance",
      "subtitle": "5 Subcategories",
      "cardColor": Colors.orange
    }
  ];
}

List<dynamic> getEsgSubCategories(String category) {
  if(category == "Environmental") {
    return [
      {
        "name": "Energy Efficiency",
        "category": "affordable_and_clean_energy"
      },
      {
        "name": "Sustainable Water Management",
        "category": "clean_water_and_sanitation"
      },
      {
        "name": "Biodiversity and Conservation",
        "category": "climate_action"
      },
      {
        "name": "Carbon Emissions",
        "category": "affordable_and_clean_energy",
      },
      {
        "name": "Environmental Policy and Report",
        "category": "quality_education"
      },
      {
        "name": "Waste Management",
        "category": "clean_water_and_sanitation"
      }
    ];
  } else if (category == "Social") {
    return [
      {
        "name": "Supply Chain Management",
        "category": "quality_education"
      },
      {
        "name": "Human Rights and Labor standards",
        "category": "quality_education"
      },
      {
        "name": "Health and Safety",
        "category": "good_health_and_wellbeing"
      },
      {
        "name": "Human Capital Management",
        "category": "decent_work_and_economic_growth"
      },
      {
        "name": "Community Relations",
        "category": "good_health_and_wellbeing"
      },
      {
        "name": "Customer Privacy",
        "category": "good_health_and_wellbeing"
      }
    ];
  } else  {
    return [
      {
        "name": "Transparency and Reporting",
        "category": "quality_education"
      },
      {
        "name": "Corporate Culture and Ethics",
        "category": "decent_work_and_economic_growth"
      },
      {
        "name": "Audit and Internal Controls",
        "category": "quality_education"
      },
      {
        "name": "Stakeholder Engagement",
        "category": "decent_work_and_economic_growth"
      },
      {
        "name": "Corporate Resilience and Adaptability",
        "category": "decent_work_and_economic_growth"
      }
    ];
  }
}


List<dynamic> getAddGoalForm() {
  return [
    {
      "section": "Basic",
      "inputs": [
        {
          "type": "dropdown",
          "Placeholder": "Select Type",
          "fromFirebase": false,
          "options": ["Measurable", "NonMeasurable"],
          "value": "Measurable",
          "displayOnlyFor": "All"
        },
        {
          "type": "text",
          "Placeholder": "Description",
          "value": "description",
          "displayOnlyFor": "All"
        },
        {
          "type": "non-measurable-text",
          "Placeholder": "Disclosure Info",
          "value": "disclosureInfo",
          "displayOnlyFor": "NonMeasurable"
        },
        {
          "type": "dropdown",
          "Placeholder": "Department",
          "fromFirebase": true,
          "databaseName": "departments",
          "value": "departments",
          "displayOnlyFor": "All"
        }
      ]
    },
    {
      "section": "Frequency",
      "inputs": [
        {
          "type": "date",
          "Placeholder": "Start Date",
          "value": "startDate",
          "displayOnlyFor": "All"
        },
        {
          "type": "date",
          "Placeholder": "Deadline",
          "value": "Deadline",
          "displayOnlyFor": "All"
        },
        {
          "type": "dropdown",
          "Placeholder": "Select Tracking Frequency",
          "fromFirebase": false,
          "options": ["Daily", "Weekly", "Monthly", "Quarterly", "Annually"],
          "value": "trackingFreq",
          "displayOnlyFor": "All"
        }
      ]
    },
    {
      "section": "Scope",
      "inputs": [
        {
          "type": "dropdown",
          "Placeholder": "Select Scope",
          "fromFirebase": false,
          "options": ["Country"],
          "value": "scope",
          "displayOnlyFor": "All"
        },
        {
          "type": "dropdown",
          "Placeholder": "Select Country",
          "fromFirebase": true,
          "databaseName": "countries",
          "value": "countries",
          "displayOnlyFor": "All"
        },
      ]
    },
    {
      "section": "Target",
      "inputs": [
        {
          "type": "text",
          "Placeholder": "Baseline Value",
          "value": "baseline",
          "displayOnlyFor": "All"
        },
        {
          "type": "text",
          "Placeholder": "Initial Value",
          "value": "initial",
          "displayOnlyFor": "All"
        },
      ]
    }
  ];
}


List<dynamic> getCarbonEmissionValuesList() {
  return [
    {
      "name": "Energy Consumption",
      "emissionFactor": 0.5,
      "emissionFactorTitle": "Emission Factor (kg CO2e per kWh)",
      "inputTitle": "Energy Consumption (kWh)"
    },
    {
      "name": "Fuel Consumption",
      "emissionFactor": 8.89,
      "emissionFactorTitle": "Emission Factor (kg CO2e per gallon)",
      "inputTitle": "Fuel Consumption (gallons)"
    },
    {
      "name": "Transportation",
      "emissionFactor": 0.411,
      "emissionFactorTitle": "Emission Factor (kg CO2e per mile)",
      "inputTitle": "Activity Data (miles travelled)"
    },
    {
      "name": "Waste Disposal",
      "emissionFactor": 1.2,
      "emissionFactorTitle": "Emission Factor (kg CO2e per kg)",
      "inputTitle": "Waste Produced (Kg)"
    }
  ];
}


List<dynamic> getDashboardCategories() {
  return [
    {
      "main": "Environmental",
      "name": "Energy Efficiency",
      "category": "affordable_and_clean_energy"
    },
    {
      "main": "Environmental",
      "name": "Sustainable Water Management",
      "category": "clean_water_and_sanitation"
    },
    {
      "main": "Environmental",
      "name": "Biodiversity and Conservation",
      "category": "climate_action"
    },
    {
      "main": "Environmental",
      "name": "Carbon Emissions",
      "category": "affordable_and_clean_energy",
    },
    {
      "main": "Environmental",
      "name": "Environmental Policy and Report",
      "category": "quality_education"
    },
    {
      "main": "Environmental",
      "name": "Waste Management",
      "category": "clean_water_and_sanitation"
    },
    {
      "main": "Social",
      "name": "Supply Chain Management",
      "category": "quality_education"
    },
    {
      "main": "Social",
      "name": "Human Rights and Labor standards",
      "category": "quality_education"
    },
    {
      "main": "Social",
      "name": "Health and Safety",
      "category": "good_health_and_wellbeing"
    },
    {
      "main": "Social",
      "name": "Human Capital Management",
      "category": "decent_work_and_economic_growth"
    },
    {
      "main": "Social",
      "name": "Community Relations",
      "category": "good_health_and_wellbeing"
    },
    {
      "main": "Social",
      "name": "Customer Privacy",
      "category": "good_health_and_wellbeing"
    },
    {
      "main": "Governance",
      "name": "Transparency and Reporting",
      "category": "quality_education"
    },
    {
      "main": "Governance",
      "name": "Corporate Culture and Ethics",
      "category": "decent_work_and_economic_growth"
    },
    {
      "main": "Governance",
      "name": "Audit and Internal Controls",
      "category": "quality_education"
    },
    {
      "main": "Governance",
      "name": "Stakeholder Engagement",
      "category": "decent_work_and_economic_growth"
    },
    {
      "main": "Governance",
      "name": "Corporate Resilience and Adaptability",
      "category": "decent_work_and_economic_growth"
    }
  ];
}

List<dynamic> getNonMeasurable() {
  return [
    {
      "name": "Human Rights 2025",
      "content": "The organization’s governance bodies and workforce demonstrate a commitment to diversity and inclusion through a balanced representation across gender, age groups, and other relevant diversity indicators. Within the governance bodies, 40% of members are female and 60% are male. The age distribution includes 20% under 30 years, 50% between 30-50 years, and 30% over 50 years. Additionally, 15% of governance body members belong to minority or vulnerable groups, reflecting the organization’s focus on inclusivity. Similarly, the organization’s workforce reflects diversity across various employee categories. Among employees, 48% are female and 52% are male. The workforce age distribution is 35% under 30 years, 45% between 30-50 years, and 20% over 50 years. Furthermore, 20% of employees belong to minority or vulnerable groups, reinforcing the organization’s commitment to fostering an inclusive and equitable workplace.",
    },
    {
      "name": "Health 2024",
      "content": "ender Breakdown: Percentage of male and female members. Age Distribution: Share of members under 30 years, between 30-50 years, and over 50 years. Other Diversity Indicators: Representation of minority or vulnerable groups (as applicable).",

    },
    {
      "name": "Case Study",
      "content": "Our occupational health services are designed to proactively identify, assess, and eliminate workplace hazards while minimizing risks associated with employee health and safety. Key functions of these services include regular ergonomic assessments for office and remote work setups, mental health support programs to address stress and burnout, and routine health check-ups to ensure early detection of potential health issues. As of this year, over 90% of employees have participated in ergonomic assessments, resulting in a 25% reduction in reported musculoskeletal complaints. Additionally, 80% of staff have engaged in mental health programs, contributing to a 30% improvement in employee satisfaction scores related to workplace wellness. These services are supported by certified health professionals who adhere to recognized industry standards, ensuring high-quality care and compliance. To facilitate worker access, Atominos Consulting provides clear communication channels, such as an online health portal used by 85% of employees and in-person consultations available at all regional offices. Confidentiality and ease of scheduling remain priorities, with 95% of users reporting satisfaction with access to these services. Regular feedback mechanisms and quarterly reviews ensure that occupational health services remain relevant and effective in addressing evolving workplace needs. This integrated approach reinforces our commitment to fostering a safe, healthy, and productive work environment for all employees.",

    },
    {
      "name": "Occupational Health Services",
      "content": "Our occupational health services are designed to proactively identify, assess, and eliminate workplace hazards while minimizing risks associated with employee health and safety. Key functions of these services include regular ergonomic assessments for office and remote work setups, mental health support programs to address stress and burnout, and routine health check-ups to ensure early detection of potential health issues. As of this year, over 90% of employees have participated in ergonomic assessments, resulting in a 25% reduction in reported musculoskeletal complaints. Additionally, 80% of staff have engaged in mental health programs, contributing to a 30% improvement in employee satisfaction scores related to workplace wellness."
    },
    {
      "name":"Ensuring Safety at Atominos Consulting",
      "content":"Atominos Consulting has implemented a robust Occupational Health and Safety Management System (OHSMS) to promote a safe and healthy work environment for all employees. The system complies with applicable legal requirements, including labor codes and workplace safety regulations relevant to the IT consulting sector. Additionally, it adheres to internationally recognized standards, such as ISO 45001, ensuring alignment with best practices in risk management and employee well-being. The OHSMS covers all full-time employees, contractors, and temporary staff involved in consulting activities, including office operations, client site engagements, and remote work environments. Notably, 100% of office and on-site operations undergo annual audits, and over 85% of employees have completed ergonomic assessments to enhance their workplace safety and comfort. Special emphasis is placed on addressing key risks in the IT consulting sector, such as mental health challenges, ergonomic concerns, and ensuring safe remote work setups. With over 70% of the workforce operating remotely, the company ensures compliance by evaluating remote work environments and providing support through virtual assessments. The system’s scope extends to all operational workplaces, including regional offices and project sites, while exclusions apply only to external service providers outside Atominos Consulting's direct control. These exclusions are justified by the independent nature of their operations. This comprehensive approach reflects the company’s commitment to cultivating a culture of health, safety, and well-being throughout its consulting ecosystem"

    },
    {
      "name":"Incidents of discrimination",
      "content":"Our organization is committed to fostering a culture of inclusion, respect, and equality. We strive to prevent incidents of discrimination by promoting comprehensive anti-discrimination policies, regular training programs for employees, and a safe environment where all concerns can be raised transparently. In instances where discrimination may occur, we ensure that proper investigative and corrective actions are taken promptly to address the situation and prevent recurrence. We continuously work towards building a respectful workplace, guided by principles of fairness and empathy, that supports the well-being and dignity of every individual."

    },
    {
      "name":"Gender Pay Ratio",
      "content":"In support of pay equity and transparency, we conduct regular reviews of the average basic salary and total remuneration for female and male employees. With a team of 14-20 employees, our goal is to achieve a 1:1 ratio, ensuring fair compensation across comparable roles. Currently, the basic salary ratio of women to men stands at 0.98:1, while the total remuneration ratio is 0.97:1. These figures indicate that, on average, women earn approximately 98% of the basic salary and 97% of the total remuneration of their male counterparts in similar roles. We recognize this gap and are committed to closing it through ongoing reviews of our compensation practices, aligning them with fair and industry-standard pay practices. To ensure continued progress, we perform annual reviews of our salary structures to maintain fairness and transparency, and we offer open channels for employees to address compensation-related concerns. As an organization, we value equal opportunity and are dedicated to fostering a fair and inclusive work environment where our compensation practices uphold our commitment to gender pay equity."

    },
    {
      "name":"Diversity and Equal Opportunity",
      "content":"Diversity and equal opportunity are vital for creating inclusive environments in workplaces, schools, and communities. Diversity involves recognizing and valuing individual differences such as race, ethnicity, gender, age, sexual orientation, disability, and more. When diversity is embraced, it brings richer perspectives, ideas, and creativity, enhancing innovation and empathy. Equal opportunity ensures fair access to resources and success for all, regardless of background. It involves removing barriers and biases that may hinder underrepresented groups, through practices like unbiased hiring, equal access to development, and inclusive policies. Together, diversity and equal opportunity foster more productive, resilient, and empathetic environments. By promoting these values, we unlock the potential for everyone to contribute fully, creating a more dynamic and just society."
    },
  ];
}