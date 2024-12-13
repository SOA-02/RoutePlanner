# LFM - RoutePlanner
RoutePlanner is designed to help students bridge the gap between their current abilities and course requirements. By analyzing syllabi and suggesting tailored resources, it provides actionable insights to guide students through their academic journey. The platform focuses on making educational resources more accessible, helping students navigate their learning paths more effectively.

## Objectives:

- Identify Knowledge Gaps: Provide students with insights into the gaps between their current knowledge and the requirements of their courses, allowing them to focus on areas needing improvement.

- Resource Alignment: Suggest relevant resources, including NTHU courses, online tutorials, and external educational platforms, that align with the student’s current syllabus and learning needs.

- Effort Estimation: Help students understand the time and effort required to meet course requirements by estimating the pressure and commitment needed for success.


### Short-term Goals:
1. Manual Syllabus Input: Allow students to manually input course names and copy-paste syllabi into the system, providing an immediate way to analyze their academic needs.

2. Gap Analysis: Use AI (e.g., ChatGPT) to analyze the syllabi, identify key concepts, prerequisites, and areas for improvement, helping students understand where they stand in relation to the course requirements.

3. Resource Matching: Suggest relevant resources based on the user ability, including NTHU on-campus courses and YouTube lectures for topics not covered by official courses.

### Long-term Goals

1. Easy Syllabus Upload: Implement a feature that allows students to upload syllabi in PDF format, reducing manual input.
2. Expand Resource Database: Extend the range of recommended resources beyond NTHU courses and YouTube, including other platforms like Coursera, edX, and specialized academic websites.
3. Personalized Learning Path: Develop a feature that generates a personalized learning path based on students' progress, preferences, and academic goals.
4. Advanced AI Insights: Enhance the AI's ability to provide more detailed analysis and actionable insights, including suggestions for study strategies and time management.


## Setup
* Create a personal YouTube Token with ```public_repo``` scope
* Copy ```config/secrets_example.yml``` to ```config/secrets.yml``` and update token 
* Ensure correct version of Ruby install (see ```.ruby-version``` for ```rbenv```)
* run bundle install

## Running Tests
To run the test: 
```
rake spec
```







