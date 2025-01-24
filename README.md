# Multi-Microphone Speech Enhancement

The project focuses on **multi-microphone speech enhancement** to improve the quality of speech signals in noisy environments. This is particularly relevant in applications like mobile phones, hearing aids, and speech recognition systems, where noise reduction is critical for usability. The system leverages the spatial diversity of multiple microphones to reduce noise and enhance the target speech signal.

## Key Objectives

### Noise Reduction in Speech Signals
- Use multiple microphones to capture speech signals contaminated with noise.
- Reduce the noise using advanced estimation techniques.

### Develop and Compare Estimators
- Implement classical and Bayesian estimation methods for noise reduction:
  - **MVUE (Minimum Variance Unbiased Estimator)**: Assumes the speech signal is deterministic.
  - **MMSE (Minimum Mean Square Error)** and **LMMSE (Linear MMSE)**: Assume the speech signal is random and use prior distributions for better performance.

### Empirical Validation
- Compare the performance of these estimators against the theoretical **Cramer-Rao Lower Bound (CRLB)**.
- Analyze how the number of microphones affects estimation accuracy.
