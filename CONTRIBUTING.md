# Contributing to Catred Config

We welcome contributions to the Catred Config project! To ensure a smooth collaboration and maintain code quality, please adhere to the following guidelines:

## Testing Requirements

All new features and bug fixes must include corresponding tests. Your contributions will only be approved if all tests pass.

- **All new features must include tests:** Before submitting a pull request, ensure that you have written unit, integration, or end-to-end tests for any new functionality you introduce.
- **Tests must pass before PR approval:** Your pull request will not be merged until all automated tests in the CI/CD pipeline pass successfully.

### How to Run Tests Locally

Before pushing your changes, you can run the test suite locally to catch issues early:

**Comprehensive Test Suite:**
```bash
./tests/test_framework.sh
```

**Specific Tests:**

For unit tests:
```bash
./tests/unit/test_your_module.sh
```

For integration tests:
```bash
./tests/integration/test_your_feature.sh
```

**Docker-based Tests:**

If you have Docker installed, you can run tests in a containerized environment:
```bash
./tests/run_docker_tests.sh all
```

## Pull Request Guidelines

- Fork the repository and create your branch from `main`.
- Ensure your code adheres to the existing style and conventions.
- Write clear, concise commit messages.
- Provide a detailed description of your changes in the pull request.
- Link to any relevant issues.

Thank you for contributing!