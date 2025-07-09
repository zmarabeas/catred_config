## Testing Procedures for AI Agents

When working on this repository, especially when making changes to the codebase, it is crucial to validate your changes through testing. Here are the commands and procedures to ensure the integrity and functionality of the Catred Config project:

### Local Validation

Before pushing any changes, always run the test suite locally:

**Comprehensive Test Suite:**
```bash
./tests/test_framework.sh
```

**Specific Tests:**

To run unit tests for specific components:
```bash
./tests/unit/test_catred_cli.sh
# Example: ./tests/unit/test_health_check.sh
# Example: ./tests/unit/test_theme_system.sh
```

To run integration tests:
```bash
./tests/integration/test_install_uninstall.sh
```

**Docker-based Tests:**

If Docker is available, you can run tests in a containerized environment for cross-platform validation:
```bash
./tests/run_docker_tests.sh all
```

### CI/CD Validation

After pushing your changes, monitor the GitHub Actions workflows to ensure all checks pass. The `test.yml` workflow will automatically run on pushes and pull requests, providing immediate feedback on the health of the codebase.

- **Check GitHub Actions tab:** Verify that the `CI` workflow (from `.github/workflows/test.yml`) runs successfully.
- **Review test results:** Analyze any failures reported by the CI pipeline and address them promptly.

By following these testing procedures, you can ensure the stability and quality of your contributions to the Catred Config project.