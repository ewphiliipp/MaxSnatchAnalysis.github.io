# 🏋️‍♂️ Snatch Motion Analysis (MATLAB)

**📌 Project Overview**

This MATLAB script analyzes the motion of a maximal snatch attempt at 110kg using trajectory data. It extracts key movement phases, calculates velocity and acceleration, and determines the forces acting on the lifter during different stages of the lift.

**🔍 Current Focus**

The script was initially used to analyze my latest max attempt, providing insights into bar path, acceleration, and force application. With further development, the method could be expanded to track multiple snatch repetitions, analyzing joint positions, angles and resultant forces to optimize technique based on individual body mechanics.

**📊 Features**

- **Motion Data Processing**: Reads trajectory data from `trajectory.csv` and converts positional data into velocity and acceleration.
- **Phase Detection**: Identifies critical points in the lift, including the pull, turnover, and catch phases.
- **Force Analysis**: Computes net forces acting on the barbell for different weight scenarios (e.g., 110kg vs. 225kg).
- **Work Calculation**: Estimates the mechanical work performed during the lift.
- **Visualization**: Generates plots for position, velocity, acceleration, and force-time graphs.
- **Customizable Parameters**: Adjustable weight values to simulate different loads.

**📂 File Structure**

- `trajectory.csv` – Contains the recorded motion data
- `snatch_analysis.m` – MATLAB script for data processing and visualization
- `README.md` – This documentation

**📈 Position, Velocity, and Acceleration Over Time**

![image](https://github.com/user-attachments/assets/f042969b-f4ef-43ba-a900-fa9e0fb7af83)




**💪 Force Analysis in Different Phases*

![image](https://github.com/user-attachments/assets/0f7ac670-dd84-46e9-bca4-01c48675a2f7)




**🔬 Analysis Results**

**Start Time:** 0.782 s  
**Work Done (110 kg):** 2235.321 J  
**Work Done (225 kg):** 4572.2475 J  

**Pull Phase**
- **Force at Start (110 kg):** 1156.6008 N  
- **Force at Peak Pull (110 kg):** 1466.059 N  
- **Force at Peak Pull (225 kg):** 2998.7571 N  

**Recovery**
- **Force at Catch (110 kg):** 1506.4562 N  
- **Force at Catch (225 kg):** 3081.3877 N  

**🚀 Future Development**

- **Multi-Repetition Tracking**: Extending the analysis to multiple snatch repetitions.
- **Joint Angle Analysis**: Extracting barbell angles and body positioning.
- **Individualized Technique Optimization**: Using data-driven insights to refine technique for specific body mechanics.

**📌 Note on Net Force and Weightlifting Technique**

The calculated net force reflects how much additional force—beyond the weight of the barbell—was required to accelerate it upward. Skilled weightlifters typically need less force due to optimized technique.

An efficient lift involves:

- Optimal joint angles and leverage,
- Effective force transfer from the legs through the body to the bar,
- Minimal wasted motion or force in non-productive directions.

**🔧 Requirements**

- MATLAB R2020b or newer

**📌 How to Use**

1. Clone or download the repository.
2. Open MATLAB and run `snatch_analysis.m`.
3. Ensure `trajectory.csv` contains valid motion data.
4. Observe the generated plots and analyze key performance metrics.

**⚠️ Disclaimer**

> This project is for personal use and experimental research. Results should be interpreted with caution when applying them to training adjustments.

