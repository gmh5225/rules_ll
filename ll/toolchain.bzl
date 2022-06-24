"""# `//ll:toolchain.bzl`

Implements `ll_toolchain` and the internally used `ll_bootstrap_toolchain`.
"""

load("//ll:attributes.bzl", "LL_TOOLCHAIN_ATTRS")
load("//ll:transitions.bzl", "ll_toolchain_transition")

def _ll_toolchain_impl(ctx):
    # We always need to invoke lld via an ld.lld -> lld symlink.
    lld_alias = ctx.actions.declare_file("ld.lld")
    ctx.actions.symlink(
        output = lld_alias,
        target_file = ctx.executable.linker,
        target_path = None,
        is_executable = True,
    )

    return [
        platform_common.ToolchainInfo(
            c_driver = ctx.executable.c_driver,
            cpp_driver = ctx.executable.cpp_driver,
            archiver = ctx.executable.archiver,
            bitcode_linker = ctx.executable.bitcode_linker,
            linker = lld_alias,
            linker_executable = ctx.executable.linker,
            offload_bundler = ctx.executable.offload_bundler,
            builtin_includes = ctx.files.builtin_includes,
            cpp_stdlib = ctx.files.cpp_stdlib,
            cpp_stdhdrs = ctx.files.cpp_stdhdrs,
            cpp_abilib = ctx.files.cpp_abilib,
            cpp_abihdrs = ctx.files.cpp_abihdrs,
            compiler_runtime = ctx.files.compiler_runtime,
            unwind_library = ctx.files.unwind_library,
            local_crt = ctx.files.local_crt,
            clang_tidy = ctx.executable.clang_tidy,
            clang_tidy_runner = ctx.executable.clang_tidy_runner,
            symbolizer = ctx.executable.symbolizer,
            machine_code_tool = ctx.executable.machine_code_tool,
            cuda_toolkit = ctx.files.cuda_toolkit,
            hip_libraries = ctx.files.hip_libraries,
            toolchain_configuration = ctx.attr.toolchain_configuration,
        ),
    ]

ll_toolchain = rule(
    implementation = _ll_toolchain_impl,
    executable = False,
    attrs = LL_TOOLCHAIN_ATTRS,
    cfg = ll_toolchain_transition,
    incompatible_use_toolchain_transition = True,
)
